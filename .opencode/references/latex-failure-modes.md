# LaTeX Failure Modes — Checklist de Verificação

Inspirado no AI Research Failure Mode Checklist (Lu et al. 2026, *Nature* 651:914-919)
e adaptado para produção de artigos LaTeX com template SBC/SBGames + engine Tectonic.

Propósito: detectar falhas que "parecem trabalho competente" mas produzem
outputs errados. Rode este checklist antes de cada build.

---

## 1. Referência Fantasma (Hallucinated Citation)

**O que é:** `\cite{chave}` apontando para chave que não existe no `.bib`.

**Detection:**
```bash
grep -oP '\\cite\{[^}]+\}' Artigo.tex | sed 's/\\cite{//;s/}//' | tr ',' '\n' | \
  while read key; do
    grep -q "{$key," Referencias/referencias.bib || echo "FANTASMA: $key"
  done
```

**Quem pega:** `check.sh` (pré-build integrity gate).

---

## 2. Figura Referenciada mas Inexistente

**O que é:** `\includegraphics{Figuras/grafico.pdf}` mas o arquivo não existe
ou o path está errado.

**Sintoma no build:** `! LaTeX Error: File 'Figuras/grafico.pdf' not found.`

**Detection:**
```bash
grep -oP '\\includegraphics(\[[^\]]*\])?\{[^}]+\}' Artigo.tex | \
  sed 's/.*{//;s/}//' | while read f; do
    [ -f "$f" ] || echo "MISSING: $f"
  done
```

---

## 3. Label Órfã (Undefined Reference)

**O que é:** `\ref{fig:grafico}` mas `\label{fig:grafico}` não existe
em nenhum arquivo `.tex` do projeto.

**Sintoma:** `LaTeX Warning: Reference 'fig:grafico' on page X undefined.`

**Detection:** `check.sh` (cross-reference entre `\ref` e `\label`).

---

## 4. Blank Line em Argumento de Comando

**O que é:** Linha em branco dentro de `\fancyhead{}`, `\fancyfoot{}`,
`\titleformat{}`, `\caption{}` — o XeTeX interpreta `\n\n` como `\par`
e quebra.

**Sintoma:** `Paragraph ended before \f@nch@fancyhf was complete`

**Detection:**
```bash
grep -Pn '^\s*$' sbgames.sty  # procura blank lines em .sty
```

---

## 5. Abstract/Resumo Desestruturado

**O que é:** Abstract ou resumo sem as seções obrigatórias em negrito
(`\textbf{Introdução:}`, `\textbf{Objetivo:}`, `\textbf{Metodologia:}`,
`\textbf{Resultados:}`).

**Detection:** `check.sh` (verifica presença dos 4 campos obrigatórios).

---

## 6. Metadados do Evento Placeholder

**O que é:** `sbgames_info.tex` ainda contém valores placeholder como
`\edicao{XXIII}`, `\trilha{Trilha}`, `\local{Cidade}`.

**Detection:** `check.sh` (grep por placeholders conhecidos).

---

## 7. Encoding quebrado (UTF-8 inválido)

**O que é:** Arquivo `.tex` ou `.sty` com bytes inválidos UTF-8, que o
XeTeX substitui por U+FFFD (�).

**Sintoma:** `warning: algorithmic.sty:11: Invalid UTF-8 byte...`

**Detection:**
```bash
find . -name '*.tex' -o -name '*.sty' | while read f; do
  iconv -f utf-8 -t utf-8 "$f" >/dev/null 2>&1 || echo "BROKEN UTF-8: $f"
done
```

---

## Como usar

Antes de compilar: `./check.sh`

O script reporta WARNING (não bloqueante) e ERROR (bloqueante — corrija
antes de compilar).
