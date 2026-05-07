# template-latex — Template LaTeX SBC/SBGames (Tectonic)

## Build commands

```bash
./check.sh              # 5-gate integrity check — ALWAYS RUN FIRST
./check.sh --strict     # warnings become errors (CI mode)
./build.sh              # compile Artigo.tex → build/Artigo.pdf
./build.sh --clean      # rm build/ then compile
./build.sh --open       # compile then xdg-open PDF
./watch.sh              # hot reload on .tex/.sty/.bib changes (needs entr)
./clean.sh              # rm build/
./clean.sh --all        # rm build/ + ~/.cache/Tectonic
```

**Command order matters:** `./check.sh` → fix errors → `./build.sh`.

## Architecture

- **Entry point:** `Artigo.tex` (contains `\documentclass`)
- **Modular parts:** `Partes/*.tex` — included via `\input{Partes/nome}` (no `.tex` extension). Tectonic resolves these automatically; **do not** add them to `Tectonic.toml`.
- **Assets:** `Figuras/` (images), `Tabelas/` (tables), `Referencias/referencias.bib`
- **Event metadata:** `sbgames_info.tex` — consumed by `\input{sbgames_info}` in `Artigo.tex`
- **Styles:** `sbc-template.sty` (base), `sbgames.sty` (fancyhdr headers), `sbc.bst` (bibliography)
- **Build output:** `build/` (gitignored)

## Critical gotchas

1. **Tectonic V1 CLI is used** — `build.sh` calls `tectonic Artigo.tex ...`. It does **not** use `tectonic -X build`, so `Tectonic.toml` is effectively ignored by the primary build script. Do not rely on `Tectonic.toml` for build flags.
2. **`check.sh` does not catch all placeholders** — Gate 2 checks for obvious placeholders but may miss edge cases. Always manually verify `sbgames_info.tex`: edition, track, year, location.
3. **Blank lines break `fancyhdr`** — A blank line inside `\fancyhead{}` or `\fancyfoot{}` (e.g. in `sbgames.sty`) causes `Paragraph ended before \f@nch@fancyhf`. Replace blank lines with `%`.
4. **`fontenc` / `inputenc` warnings are harmless** — `\usepackage[T1]{fontenc}` and `\usepackage[utf8]{inputenc}` are pdflatex-specific. Tectonic (XeTeX) ignores them. Do not "fix" by removing them unless the user asks.
5. **First compilation is slow** — Tectonic downloads fonts on first run. Subsequent builds are instant.

## Validation (check.sh gates)

| Gate | Checks                                                                                                           | Severity |
| ---- | ---------------------------------------------------------------------------------------------------------------- | -------- |
| 1    | `\input`, `\include`, `\includegraphics`, `\bibliography` targets exist                                                  | ERROR    |
| 2    | `sbgames_info.tex` lacks placeholders                                                                                  | WARNING  |
| 3    | Abstract/Resumo contain `Introduction/Introdução`, `Objective/Objetivo`, `Methodology/Metodologia`, `Results/Resultados` | WARNING  |
| 4    | Every `\cite{key}` has a matching entry in `Referencias/referencias.bib`                                             | WARNING  |
| 5    | All `.tex`, `.sty`, `.bib` files are valid UTF-8                                                                       | ERROR    |

## Repo conventions

- **Use `\cite{key}` only.** `\citeonline{}` is forbidden.
- **Abstract/Resumo must be structured** with 4 bold fields (`\textbf{Introdução:}` etc.).
- **Commit `.opencode/agents/` and `.opencode/rules/`**, but **not** `.opencode/node_modules/` (gitignored).
- **Do not commit `build/`**.

## OpenCode configuration

- Agent definition: `.opencode/agents/latex-author.md`
- Always-loaded references: `.opencode/references/*.md`
- Conditional rules: `.opencode/rules/*.md` (loaded automatically by OpenCode)
- LSP/MCP config: `.opencode/opencode.json`
