#!/usr/bin/env bash
set -euo pipefail

PROJ_DIR="$(cd "$(dirname "$0")" && pwd)"
BUILD_DIR="${PROJ_DIR}/build"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

ALL=false
for arg in "$@"; do
    case "$arg" in
        --all) ALL=true ;;
        --help|-h)
            echo "Uso: ./clean.sh [--all]"
            echo "  --all     Remove tambem cache Tectonic (~/.cache/Tectonic)"
            exit 0 ;;
    esac
done

echo -e "${GREEN}[CLEAN]${NC} Removendo ${BUILD_DIR} ..."
rm -rf "$BUILD_DIR"
echo -e "${GREEN}[CLEAN]${NC} build/ removido."

if $ALL; then
    echo -e "${YELLOW}[CLEAN]${NC} Removendo cache Tectonic ..."
    rm -rf ~/.cache/Tectonic
    echo -e "${GREEN}[CLEAN]${NC} Cache removido."
fi
