---
globs:
  - "**/*.tex"
  - "**/*.sty"
  - "**/*.cls"
keywords:
  - compilar
  - compilação
  - build
  - pdf
  - tectonic
  - latex
tools:
  - bash
match: any
---

# Regras de Build LaTeX

## Compilação com Tectonic

Use SEMPRE os scripts do projeto. Não invente comandos novos.

```bash
./build.sh              # compilar → build/Artigo.pdf
./build.sh --clean      # limpar build/ + compilar
./build.sh --open       # compilar + abrir PDF
./watch.sh              # hot reload (entr)
./clean.sh              # limpar build/
```

## Flags Canônicas

Quando precisar rodar Tectonic diretamente:
```bash
tectonic Artigo.tex -o build/ -k --keep-logs -p -Z paper-size=a4
```

NUNCA use `-X build` com `-o` — `build` lê Tectonic.toml e não aceita `-o`.
Se precisar de output customizado, use `tectonic -X compile Artigo.tex -o build/`.

## Verificação Pós-Build

Após compilar, verifique:
- [ ] PDF gerado em `build/Artigo.pdf`
- [ ] Nenhum `error:` no output (warnings são aceitáveis)
- [ ] `Citation undefined` apenas para placeholders (knuth:84, boulic:91, smith:99)
- [ ] Figuras visíveis
- [ ] Bibliografia formatada
