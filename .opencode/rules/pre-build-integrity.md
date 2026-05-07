---
keywords:
  - compilar
  - build
  - compilação
  - checar
  - check
  - verificar
  - validar
  - integridade
  - integrity
tools:
  - bash
match: any
---

# Regra: Integrity Gate Pré-Build

ANTES de rodar `./build.sh` ou `tectonic`, execute SEMPRE:

```bash
./check.sh
```

Se houver ERRORs, corrija ANTES de compilar.
Se houver WARNINGs, revise e decida.

## O que o check.sh verifica

1. **Arquivos referenciados** — todo `\input`, `\include`, `\includegraphics`, `\bibliography` aponta para arquivo existente (ERROR)
2. **Metadados** — `sbgames_info.tex` sem placeholders (ERROR)
3. **Resumo estruturado** — 4 campos obrigatórios presentes (WARNING)
4. **Consistência de labels** — `\ref` ↔ `\label`, `\cite` ↔ `.bib` (WARNING)
5. **Encoding** — arquivos UTF-8 válidos (WARNING)

## Fluxo

```
Escrever/editar → ./check.sh → ERROR? Corrigir → ./build.sh
                              → WARNING? Revisar → ./build.sh
                              → OK → ./build.sh
```

Inspirado nos integrity gates do ARS (Stage 2.5 e 4.5).
