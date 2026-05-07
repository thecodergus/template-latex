# template-latex

Template LaTeX para artigos acadêmicos nos formatos SBC e SBGames,
com ambiente de desenvolvimento Tectonic pronto para uso.

## Estrutura

```
template-latex/
  Artigo.tex              ← arquivo principal (modelo de artigo)
  sbgames_info.tex         ← metadados do evento SBGames
  sbc-template.sty         ← estilo SBC
  sbgames.sty              ← estilo SBGames (headers customizados)
  sbc.bst                  ← formato bibliográfico SBC
  caption2.sty             ← compatibilidade com caption
  Figuras/                 ← figuras do artigo
  Tabelas/                 ← tabelas do artigo
  Referencias/             ← arquivo .bib
  build.sh                 ← compilar → PDF
  watch.sh                 ← hot reload (requer entr)
  clean.sh                 ← limpar artefatos
  Tectonic.toml            ← configuração V2
  .vscode/                 ← VS Code + LaTeX Workshop
```

## Pré-requisitos

- [Tectonic](https://tectonic-typesetting.github.io/) >= 0.16
- (opcional) [entr](http://eradman.com/entrproject/) para watch mode

## Uso rápido

```bash
# Clonar o template para um novo artigo
git clone https://github.com/thecodergus/template-latex.git meu-artigo
cd meu-artigo
rm -rf .git && git init

# Compilar
./build.sh --clean --open

# Desenvolvimento com hot reload
./watch.sh

# Limpar build
./clean.sh
```

## Personalizando para seu artigo

1. Edite `Artigo.tex`: título, autores, resumo, conteúdo
2. Edite `sbgames_info.tex`: metadados do evento (edição, trilha, ano, local)
3. Adicione figuras em `Figuras/` e tabelas em `Tabelas/`
4. Adicione referências em `Referencias/referencias.bib`
5. Compile: `./build.sh`

## VS Code

Abra a pasta no VS Code e aceite instalar as extensões recomendadas.
O LaTeX Workshop compila automaticamente ao salvar (Ctrl+S).

Atalhos:
- `Ctrl+Alt+B` — Compilar
- `Ctrl+Alt+V` — Ver PDF
- `Ctrl+Click` no PDF — Navegar para o fonte (SyncTeX)

## Licença

MIT — use como quiser.
