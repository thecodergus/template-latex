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
| LSP | texlab 5.25+ (sintaxe), ltex-ls 16.0+ (gramática pt-BR/en), taplo 0.9+ (TOML) |

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
  agents/latex-author.md ← agente principal
  rules/                 ← 7 regras condicionais (globs + keywords)
  references/            ← 5 referências always-loaded
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

### Slash Commands (OpenCode)
```
/build      → compilar com build.sh --clean, analisar .log se erro
/check      → verificar integridade (5 gates + strict mode)
/clean      → limpar build/ e cache Tectonic
/validate   → validação completa (check.sh + .bib + labels + placeholders)
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

## Ferramentas de Edição

### LSPs (Language Servers)

Configurados em `.opencode/opencode.json` → `lsp`:

| LSP | Versão | Extensões | Função |
|-----|--------|-----------|--------|
| texlab | 5.25+ | `.tex`, `.sty`, `.cls`, `.bib` | Diagnóstico LaTeX, autocomplete, forward/reverse search, goto definition |
| ltex-ls | 16.0+ | `.tex`, `.md` | Grammar/spell check multilíngue (pt-BR + en) |
| taplo | 0.9+ | `.toml` | Validação Tectonic.toml |

Instalação:
```bash
# texlab — cargo ou pre-built
cargo install texlab

# ltex-ls — download pre-built (Java incluso)
# https://github.com/valentjn/ltex-ls/releases/latest
# extrair e symlink ltex-ls-*/bin/ltex-ls → ~/.local/bin/ltex-ls

# taplo
cargo install taplo-cli --locked
```

### MCPs (Model Context Protocol)

Os MCPs de pesquisa acadêmica (arxiv, semantic-scholar, websearch) são
configurados globalmente no Hermes (`~/.hermes/config.yaml`) com
`inherit_mcp_toolsets: true`.  Não precisam ser repetidos no projeto.

## Filosofia de Pipeline (Inspirado no ARS)

> **AI is your copilot, not the pilot.** Este template fornece ferramentas para
> automatizar o trabalho braçal — compilação, verificação de integridade,
> formatação — enquanto o pesquisador mantém controle sobre as decisões
> intelectuais: definição do problema, método, interpretação dos dados,
> e a frase depois de "Eu argumento que...".

### Estágios do Pipeline

```
Stage 1: ESCREVER   → editar Artigo.tex + Partes/*.tex
Stage 2: VERIFICAR  → /check (integrity gate)
Stage 3: COMPILAR   → /build
Stage 4: VALIDAR    → /validate (completo: .bib + labels + placeholders)
Stage 5: REVISAR    → ler PDF, revisar conteúdo
Stage 6: COMMITAR   → git commit
```

### Integrity Gate (check.sh)

Antes de cada build, o `check.sh` executa 5 verificações:

| Gate | O que verifica | Severidade |
|------|---------------|------------|
| 1 | Arquivos referenciados existem | ERROR |
| 2 | Metadados sem placeholders | WARNING |
| 3 | Resumo estruturado (4 campos) | WARNING |
| 4 | Citações têm entrada no .bib | WARNING |
| 5 | Encoding UTF-8 válido | ERROR |

### 7 Modos de Falha (adaptado de Lu et al. 2026, *Nature*)

Estas falhas "parecem trabalho competente" mas produzem outputs errados:

1. Referência fantasma — `\cite{}` sem entrada no `.bib`
2. Figura inexistente — `\includegraphics` apontando para path errado
3. Label órfã — `\ref{}` sem `\label{}` correspondente
4. Blank line em argumento — `\n\n` dentro de `\fancyhead{}`
5. Resumo desestruturado — faltam seções obrigatórias
6. Metadados placeholder — "XXIII", "Trilha", "Cidade"
7. Encoding quebrado — bytes UTF-8 inválidos

Documento completo: `.opencode/references/latex-failure-modes.md`

## Regras Condicionais (.opencode/rules/)

As regras são carregadas automaticamente quando o contexto dispara os gatilhos
(globs nos arquivos editados + keywords na conversa):

| Regra | Gatilho | Função |
|-------|---------|--------|
| `latex-build.md` | `.tex/.sty/.cls` + build/tectonic | Compilação, flags, verificação pós-build |
| `latex-citations.md` | `.tex/.bib` + citar/cite | Integridade de citações, proibição `\citeonline`, verificação |
| `latex-figures-tables.md` | `.tex` + figura/tabela/caption | Legendas analíticas, anotação estatística, precisão quantitativa |
| `latex-references.md` | `.bib` + referência/bibtex | Formato de chaves, campos obrigatórios, verificação .tex↔.bib |
| `latex-style.md` | `.sty/.cls/.tex` + estilo/fancyhdr | Template SBC, blank lines, metadados |
| `pre-build-integrity.md` | check/verificar/validação | Integrity gate obrigatório antes de compilar |
| `writing-quality.md` | `.tex` + escrever/seção/revisão | Qualidade de escrita, princípios científicos, checklist |

## Referências Always-Loaded (.opencode/references/)

Carregadas em toda sessão do agente `latex-author`:

| Referência | Conteúdo |
|-----------|----------|
| `latex-failure-modes.md` | Checklist dos 7 modos de falha com comandos de detecção |
| `writing-quality-guide.md` | Voz autoral, densidade de informação, ativa vs passiva |
| `build-integrity-checklist.md` | 6 gates detalhados pré-compilação |
| `factual-validation-workflow.md` | Pipeline de validação de claims (extração PDF, confronto, verificação online) |
| `systematic-reading-pipeline.md` | Pipeline P/S/R 6 fases para revisão de literatura |

### Qualidade de Escrita

Consulte `.opencode/references/writing-quality-guide.md` para:
- Padrões de prosa de IA a evitar
- Checklist de voz autoral
- Densidade de informação
- Voz ativa vs passiva no português acadêmico

### Validação Factual

Consulte `.opencode/references/factual-validation-workflow.md` para:
- Extração e confronto de claims contra PDFs fonte
- Verificação bibliográfica online (Semantic Scholar)
- Correção de discrepâncias

### Leitura Sistemática

Consulte `.opencode/references/systematic-reading-pipeline.md` para:
- Template P/S/R por paper
- Matriz cross-paper
- Gap analysis
- Geração de tabela comparativa LaTeX
