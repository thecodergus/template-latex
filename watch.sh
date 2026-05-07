#!/usr/bin/env bash
set -euo pipefail

PROJ_DIR="$(cd "$(dirname "$0")" && pwd)"
OPEN=false

for arg in "$@"; do
    case "$arg" in
        --open|-o) OPEN=true ;;
        --help|-h)
            echo "Uso: ./watch.sh [--open]"
            echo "  --open, -o   Abre o PDF a cada rebuild"
            exit 0 ;;
    esac
done

if ! command -v entr &>/dev/null; then
    echo "ERRO: 'entr' nao encontrado. Instale com: sudo apt install entr"
    exit 1
fi

GREEN='\033[0;32m'
NC='\033[0m'

BUILD_CMD="bash ${PROJ_DIR}/build.sh"
$OPEN && BUILD_CMD="${BUILD_CMD} --open"

echo -e "${GREEN}[WATCH]${NC} Observando ${PROJ_DIR} ..."
echo -e "${GREEN}[WATCH]${NC} Ctrl+C para parar."
echo ""

find "$PROJ_DIR" -type f \( \
    -name '*.tex' -o -name '*.sty' -o -name '*.bib' \
    -o -name '*.cls' -o -name '*.bst' \
    \) -not -path '*/build/*' -not -path '*/.git/*' \
    | entr -d bash -c "$BUILD_CMD"
