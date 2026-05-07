# template-latex — Projeto de Template LaTeX Acadêmico

Template para artigos nos formatos SBC e SBGames com ambiente Tectonic.

## Stack

| Camada | Tecnologia |
|--------|-----------|
| Engine | Tectonic 0.16+ (XeTeX-based, single binary) |
| Template | sbc-template.sty + sbgames.sty |
| Bibliografia | BibTeX + sbc.bst |
| Build | build.sh (V1 CLI), Tectonic.toml (V2 bridge) |
| Watch | watch.sh (entr) |
| Editor | VS Code + LaTeX Workshop |

## Estrutura de Arquivos

```
Artigo.tex              ← documento principal (contém \documentclass)
sbgames_info.tex         ← metadados do evento (edição, trilha, ano, local)
sbc-template.sty         ← estilo SBC (geometria, fontes, seções)
sbgames.sty              ← headers SBGames via fancyhdr
sbc.bst                  ← estilo bibliográfico SBC
caption2.sty             ← compatibilidade caption
Figuras/                 ← figuras do artigo (.jpg, .pdf, .png)
Tabelas/                 ← tabelas do artigo
Referencias/             ← referencias.bib (BibTeX)
build.sh                 ← compilar → build/Artigo.pdf
watch.sh                 ← hot reload (requer entr)
clean.sh                 ← limpar build/ e cache Tectonic
Tectonic.toml            ← configuração V2
.vscode/                 ← VS Code settings + LaTeX Workshop
.opencode/               ← AI agent config (OpenCode)
```

## Convenções

### Nomenclatura
- Arquivo principal: `Artigo.tex`
- Partes: `Partes/*.tex` (usar `\input{Partes/nome}`)
- Figuras: `Figuras/` com nomes descritivos
- Referências: `Referencias/referencias.bib`
- Build output: `build/` (gitignorado)

### Encoding e Idioma
- UTF-8 (XeTeX nativo)
- Idioma principal: Português (Brasil) via `\usepackage[brazilian]{babel}`
- Resumo bilíngue: `\begin{abstract}...\end{abstract}` + `\begin{resumo}...\end{resumo}`

### Comandos de Build
```bash
./build.sh              # compilar
./build.sh --clean      # limpar + compilar
./build.sh --open       # compilar + abrir PDF
./watch.sh              # hot reload
./clean.sh              # limpar build/
./clean.sh --all        # limpar build/ + cache Tectonic
```

### Tectonic Flags Canônicas
`-o build/ -k --keep-logs -p -Z paper-size=a4`

### Pacotes Obrigatórios
- `sbc-template` — estilo base SBC
- `sbgames` — headers SBGames
- `[brazilian]{babel}` — idioma
- `graphicx` — figuras
- `url` — URLs nos references

### Pacotes Pdflatex-Específicos (inofensivos no XeTeX)
- `\usepackage[T1]{fontenc}` — ignorado, warning inofensivo
- `\usepackage[utf8]{inputenc}` — ignorado, warning inofensivo

## Pitfalls Conhecidos

1. **Blank lines em `\fancyhead`/`\fancyfoot`** → `Paragraph ended before \f@nch@fancyhf`
   Solução: substituir linha em branco por `%` no .sty

2. **`! Emergency stop` genérico** → erro de sintaxe LaTeX, ler .log

3. **Cache na primeira compilação** → Tectonic baixa fontes, pode demorar. Compilações seguintes são instantâneas.

4. **Espaços em paths** → sempre usar aspas ao referenciar o diretório

## Referências
- Tectonic: https://tectonic-typesetting.github.io/
- SBC Template: https://www.sbc.org.br/documentos-da-sbc/summary/169-templates-para-artigos-e-capitulos-de-livros/878-modelosparapublicaodeartigos
- SBGames: https://www.sbgames.org/
