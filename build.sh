#!/usr/bin/env bash
set -euo pipefail

PROJ_DIR="$(cd "$(dirname "$0")" && pwd)"
MAIN_TEX="Artigo.tex"
BUILD_DIR="${PROJ_DIR}/build"
FLAGS="-k --keep-logs -p -Z paper-size=a4"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log()  { echo -e "${GREEN}[BUILD]${NC} $*"; }
warn() { echo -e "${YELLOW}[AVISO]${NC} $*"; }
err()  { echo -e "${RED}[ERRO]${NC} $*"; exit 1; }

CLEAN=false
OPEN=false

for arg in "$@"; do
    case "$arg" in
        --clean|-c) CLEAN=true ;;
        --open|-o)  OPEN=true ;;
        --help|-h)
            echo "Uso: ./build.sh [--clean] [--open]"
            echo "  --clean, -c   Remove build/ antes de compilar"
            echo "  --open, -o    Abre o PDF apos compilar (xdg-open)"
            echo "  --help, -h    Mostra esta ajuda"
            exit 0 ;;
        *) err "Argumento desconhecido: $arg" ;;
    esac
done

if $CLEAN; then
    log "Limpando build/ ..."
    rm -rf "$BUILD_DIR"
fi

mkdir -p "$BUILD_DIR"
log "Compilando ${MAIN_TEX} → ${BUILD_DIR}/ ..."
cd "$PROJ_DIR"

if tectonic "$MAIN_TEX" -o "$BUILD_DIR" $FLAGS; then
    log "Compilacao concluida!"
    PDF="${BUILD_DIR}/$(basename "$MAIN_TEX" .tex).pdf"
    [ -f "$PDF" ] && log "PDF: ${PDF} ($(du -h "$PDF" | cut -f1))"
else
    err "Compilacao falhou. Log: ${BUILD_DIR}/$(basename "$MAIN_TEX" .tex).log"
fi

if $OPEN; then
    PDF="${BUILD_DIR}/$(basename "$MAIN_TEX" .tex).pdf"
    [ -f "$PDF" ] && xdg-open "$PDF" 2>/dev/null || warn "xdg-open falhou"
fi
