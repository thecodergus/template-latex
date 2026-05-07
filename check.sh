#!/usr/bin/env bash
set -uo pipefail
# NOTA: sem 'set -e' — o script gerencia erros manualmente via $ERRORS

# ============================================================
# check.sh — Build Integrity Gate
# Inspirado nos integrity gates do ARS (Stage 2.5 e 4.5)
# ============================================================

PROJ_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$PROJ_DIR"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

ERRORS=0
WARNINGS=0
STRICT=false

for arg in "$@"; do
    case "$arg" in
        --strict) STRICT=true ;;
        --help|-h)
            echo "Uso: ./check.sh [--strict]"
            echo "  --strict    WARNINGs viram ERRORs (para CI)"
            exit 0 ;;
        *) echo -e "${RED}[ERRO]${NC} Argumento desconhecido: $arg"; exit 1 ;;
    esac
done

pass()  { printf "  ${GREEN}✓${NC} %s\n" "$*"; }
warn()  { printf "  ${YELLOW}⚠${NC} %s\n" "$*"; WARNINGS=$((WARNINGS + 1)); }
fail()  { printf "  ${RED}✗${NC} %s\n" "$*"; ERRORS=$((ERRORS + 1)); }
info()  { printf "  ${CYAN}ℹ${NC} %s\n" "$*"; }
header() { printf "\n${CYAN}━━━${NC} %s ${CYAN}━━━${NC}\n" "$*"; }

# Helper: extract LaTeX command arguments from a file
# Usage: latex_args "input" Artigo.tex
latex_args() {
    local cmd="$1" file="$2"
    # Match \cmd{arg} — handles both \input{file} and \input{path/file}
    grep -o "\\\\${cmd}{[^}]*}" "$file" 2>/dev/null | sed "s/\\\\${cmd}{//;s/}//" || true
}

MAIN_TEX="Artigo.tex"

# ============================================================
header "Gate 1: Arquivos Referenciados"

if [ ! -f "$MAIN_TEX" ]; then
    fail "Arquivo principal '$MAIN_TEX' não encontrado"
else
    pass "Arquivo principal '$MAIN_TEX'"

    # Check \input e \include
    for ref in $(latex_args "input" "$MAIN_TEX"; latex_args "include" "$MAIN_TEX"); do
        [ -z "$ref" ] && continue
        if [ -f "$ref" ]; then
            pass "\\input{$ref}"
        elif [ -f "${ref}.tex" ]; then
            pass "\\input{$ref} → ${ref}.tex"
        else
            fail "\\input{$ref}: não encontrado"
        fi
    done

    # Check \includegraphics
    for ref in $(grep -o '\\\\includegraphics[^}]*}' "$MAIN_TEX" 2>/dev/null | \
                 sed 's/.*{//;s/}//' || true); do
        [ -z "$ref" ] && continue
        if [ -f "$ref" ]; then
            pass "\\includegraphics{$ref}"
        else
            fail "\\includegraphics{$ref}: não encontrado"
        fi
    done

    # Check \bibliography
    for ref in $(latex_args "bibliography" "$MAIN_TEX"); do
        [ -z "$ref" ] && continue
        if [ -f "${ref}.bib" ]; then
            pass "\\bibliography{$ref} → ${ref}.bib"
        else
            fail "\\bibliography{$ref}: .bib não encontrado"
        fi
    done
fi

# ============================================================
header "Gate 2: Metadados do Evento"

INFO_TEX="sbgames_info.tex"

if [ -f "$INFO_TEX" ]; then
    ph_found=0
    for ph in "XXIII" "Trilha" "Cidade"; do
        if grep -q "$ph" "$INFO_TEX" 2>/dev/null; then
            warn "Placeholder '$ph' em $INFO_TEX (esperado em template)"
            ph_found=1
        fi
    done
    if [ "$ph_found" -eq 0 ]; then
        pass "Metadados sem placeholders óbvios"
    fi
else
    fail "$INFO_TEX não encontrado"
fi

# ============================================================
header "Gate 3: Estrutura do Resumo"

abstract_ok=true
resumo_ok=true

grep -q 'Introduction' "$MAIN_TEX" 2>/dev/null || abstract_ok=false
grep -q 'Objective'   "$MAIN_TEX" 2>/dev/null || abstract_ok=false
grep -q 'Methodology'  "$MAIN_TEX" 2>/dev/null || abstract_ok=false
grep -q 'Results'     "$MAIN_TEX" 2>/dev/null || abstract_ok=false

grep -q 'Introdução'  "$MAIN_TEX" 2>/dev/null || resumo_ok=false
grep -q 'Objetivo'    "$MAIN_TEX" 2>/dev/null || resumo_ok=false
grep -q 'Metodologia'  "$MAIN_TEX" 2>/dev/null || resumo_ok=false
grep -q 'Resultados'  "$MAIN_TEX" 2>/dev/null || resumo_ok=false

if $abstract_ok; then
    pass "Abstract estruturado (4 campos)"
else
    warn "Abstract pode não estar estruturado"
fi

if $resumo_ok; then
    pass "Resumo estruturado (4 campos)"
else
    warn "Resumo pode não estar estruturado"
fi

# ============================================================
header "Gate 4: Consistência de Citações"

BIB_FILE="Referencias/referencias.bib"

if [ -f "$BIB_FILE" ]; then
    # Extrai chaves de \cite{key1,key2}
    CITE_KEYS=$(grep -o '\\cite{[^}]*}' "$MAIN_TEX" 2>/dev/null | \
        sed 's/\\cite{//;s/}//' | tr ',' '\n' | \
        sed 's/^ *//;s/ *$//' | sort -u || true)
    if [ -n "$CITE_KEYS" ]; then
        echo "$CITE_KEYS" | while read -r key; do
            [ -z "$key" ] && continue
            if grep -q "{$key," "$BIB_FILE" 2>/dev/null; then
                pass "\\cite{$key}"
            else
                warn "\\cite{$key}: não encontrada em $BIB_FILE"
            fi
        done
    else
        info "Nenhuma \\cite encontrada"
    fi
else
    warn "$BIB_FILE não encontrado"
fi

# ============================================================
header "Gate 5: Encoding UTF-8"

find "$PROJ_DIR" \( -name '*.tex' -o -name '*.sty' -o -name '*.bib' \) \
    -not -path '*/build/*' -not -path '*/.git/*' 2>/dev/null | \
    while read -r f; do
    if iconv -f utf-8 -t utf-8 "$f" >/dev/null 2>&1; then
        pass "UTF-8: $f"
    else
        fail "UTF-8 inválido: $f"
    fi
done

# ============================================================
header "Resultado"

if [ "$STRICT" = true ]; then
    TOTAL=$((ERRORS + WARNINGS))
else
    TOTAL=$ERRORS
fi

if [ "$TOTAL" -eq 0 ]; then
    echo -e "\n${GREEN}✓ Todos os gates passaram.${NC}"
    echo -e "  Pronto para compilar: ${CYAN}./build.sh${NC}"
    exit 0
else
    echo -e "\n${RED}✗ $ERRORS erro(s), $WARNINGS warning(s)${NC}"
    if [ "$STRICT" = true ]; then
        echo -e "  Modo estrito: corrija todos antes de compilar."
    else
        echo -e "  Corrija os erros antes de compilar. Warnings são informativos."
    fi
    [ "$ERRORS" -gt 0 ] && exit 1
    exit 0
fi
