# template-latex

Template LaTeX para artigos acadêmicos nos formatos SBC e SBGames,
com ambiente de desenvolvimento Tectonic pronto para uso.

## Estrutura

```
template-latex/
  Artigo.tex              ← arquivo principal (modelo de artigo)
  Partes/
    intro.tex              ← exemplo de arquivo modular (\input)
  sbgames_info.tex         ← metadados do evento SBGames
  sbc-template.sty         ← estilo SBC
  sbgames.sty              ← estilo SBGames (headers customizados)
  sbc.bst                  ← formato bibliográfico SBC
  caption2.sty             ← compatibilidade com caption
  Figuras/                 ← figuras do artigo
  Tabelas/                 ← tabelas do artigo
  Referencias/
    referencias.bib         ← arquivo .bib
  build.sh                 ← compilar → PDF
  check.sh                 ← verificação de integridade (5 gates)
  watch.sh                 ← hot reload (requer entr)
  clean.sh                 ← limpar artefatos
  Tectonic.toml            ← configuração V2
  .vscode/                 ← VS Code + LaTeX Workshop
  .opencode/               ← AI agent config (OpenCode)
```

## Pré-requisitos

### Engine LaTeX

| Pacote | Versão | Como instalar |
|--------|--------|---------------|
| Tectonic | >= 0.16 | [GitHub Releases](https://github.com/tectonic-typesetting/tectonic/releases) ou `cargo install tectonic` |

Tectonic é o engine. É um binário único, baixa fontes sob demanda.
Não requer TeXLive nem MikTeX.

**Linux:**
```bash
# Opção A: download direto
curl -L https://github.com/tectonic-typesetting/tectonic/releases/latest/download/tectonic-*.tar.gz | tar xz
sudo mv tectonic /usr/local/bin/

# Opção B: cargo (precisa Rust)
cargo install tectonic
```

**macOS:**
```bash
brew install tectonic
```

### Language Servers (LSPs)

LSPs fornecem diagnóstico, autocomplete e navegação no editor:

| LSP | Versão | Extensões | Função |
|-----|--------|-----------|--------|
| texlab | >= 5.25 | `.tex`, `.sty`, `.cls`, `.bib` | Diagnóstico LaTeX, goto definition, forward/reverse search |
| ltex-ls | >= 16.0 | `.tex`, `.md` | Grammar/spell check pt-BR + en |
| taplo | >= 0.9 | `.toml` | Validação de Tectonic.toml |

**texlab** (obrigatório para edição confortável):
```bash
# Linux/macOS
cargo install texlab
# ou baixar pre-built de https://github.com/latex-lsp/texlab/releases
```

**ltex-ls** (recomendado — pega erros de português):
```bash
# Download pre-built (Java incluso, não precisa instalar Java):
# https://github.com/valentjn/ltex-ls/releases/latest
# Baixar ltex-ls-*-linux-x64.tar.gz, extrair, symlink:
tar xzf ltex-ls-*.tar.gz
ln -s $(pwd)/ltex-ls-*/bin/ltex-ls ~/.local/bin/ltex-ls
```

**taplo** (opcional — só valida Tectonic.toml):
```bash
cargo install taplo-cli --locked
```

### Ferramentas Auxiliares

| Ferramenta | Necessária? | Como instalar |
|-----------|-------------|---------------|
| entr | Opcional (watch mode) | `sudo apt install entr` (Debian) / `brew install entr` (macOS) |
| git | Sim | `sudo apt install git` / `brew install git` |
| Rust + Cargo | Só se for compilar LSPs | `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh` |
| zathura (ou qualquer PDF viewer) | Para --open | `sudo apt install zathura` |

### Pacotes LaTeX Inclusos

O template já inclui tudo que precisa — **nenhum pacote LaTeX adicional é necessário**:

| Arquivo | O que faz | Origem |
|---------|-----------|--------|
| `sbc-template.sty` | Layout SBC (margens, fontes, seções) | [SBC](https://www.sbc.org.br/documentos-da-sbc/summary/169-templates-para-artigos-e-capitulos-de-livros/878-modelosparapublicaodeartigos) |
| `sbgames.sty` | Headers SBGames via fancyhdr | SBGames |
| `sbc.bst` | Estilo bibliográfico SBC | SBC |
| `caption2.sty` | Compatibilidade legada com caption | CTAN |

### VS Code (opcional)

Extensões recomendadas (`.vscode/extensions.json` — aceitar ao abrir o projeto):

- `tectonic-typesetting.tectonic` — integração Tectonic
- `james-yu.latex-workshop` — preview PDF, SyncTeX, autocompile
- `valentjn.vscode-ltex` — grammar/spell check via ltex-ls
- `tamasfe.even-better-toml` — suporte a TOML (usa taplo internamente)

## Uso rápido

```bash
# Clonar o template para um novo artigo
git clone https://github.com/thecodergus/template-latex.git meu-artigo
cd meu-artigo
rm -rf .git && git init

# Verificar integridade (5 gates)
./check.sh

# Compilar
./build.sh --clean --open

# Desenvolvimento com hot reload (requer entr)
./watch.sh

# Limpar build
./clean.sh
```

## Personalizando para seu artigo

1. Edite `sbgames_info.tex`: metadados do evento (edição, trilha, ano, local)
2. Edite `Artigo.tex`: título, autores, resumo, conteúdo
3. Edite `Partes/intro.tex` (ou crie novos arquivos e use `\input{Partes/nome}`)
4. Adicione figuras em `Figuras/` e tabelas em `Tabelas/`
5. Adicione referências em `Referencias/referencias.bib`
6. Rode `./check.sh` para validar integridade
7. Compile: `./build.sh`

### Fluxo com AI Agent (OpenCode)

O projeto inclui um agente `latex-author` em `.opencode/agents/` e 5 regras
em `.opencode/rules/`.  O agente conhece:

- Convenções de nomenclatura e estrutura de arquivos
- Comandos de build (`./build.sh`, `./check.sh`)
- Pitfalls comuns (blank lines em fancyhead, placeholders, encoding)
- Padrões de qualidade de escrita acadêmica
- Os 7 modos de falha na geração de LaTeX

## Integrity Gate (check.sh)

Antes de cada build, o `check.sh` executa 5 verificações:

| Gate | O que verifica | Severidade |
|------|---------------|------------|
| 1 | Arquivos referenciados existem | ERROR |
| 2 | Metadados sem placeholders | WARNING |
| 3 | Resumo estruturado (4 campos) | WARNING |
| 4 | Citações têm entrada no .bib | WARNING |
| 5 | Encoding UTF-8 válido | ERROR |

Use `./check.sh --strict` para transformar warnings em erros (recomendado
antes da submissão final).

## Atalhos no VS Code

- `Ctrl+Alt+B` — Compilar
- `Ctrl+Alt+V` — Ver PDF
- `Ctrl+Click` no PDF — Navegar para o fonte (SyncTeX)

## Troubleshooting

### "Permission denied" ao rodar scripts
```bash
chmod +x build.sh check.sh watch.sh clean.sh
```

### "Command not found: tectonic"
Tectonic não está no PATH. Verifique a instalação ou use `cargo install tectonic`.

### "Paragraph ended before \f@nch@fancyhf"
Linha em branco dentro de `\fancyhead{}` ou `\fancyfoot{}` no `.sty`.
Substitua por `%` (comentário vazio).

### Primeira compilação demora
Tectonic baixa fontes na primeira execução. Compilações seguintes são
instantâneas (cache em `~/.cache/Tectonic/`).

### Warnings de inputenc/fontenc no build
Normal. `\usepackage[T1]{fontenc}` e `\usepackage[utf8]{inputenc}` são
pdflatex-específicos. O XeTeX (usado pelo Tectonic) ignora — warnings
inofensivos.

## Licença

MIT — use como quiser.
