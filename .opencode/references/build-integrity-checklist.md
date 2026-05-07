# Build Integrity Checklist — Verificação Pré-Compilação

Inspirado nos integrity gates do ARS (Stage 2.5 e 4.5).
Rode antes de cada `./build.sh` ou `git commit`.

---

## Gate 1: Arquivos Referenciados (BLOQUEANTE)

- [ ] `\input{Partes/intro}` → `Partes/intro.tex` existe?
- [ ] `\input{sbgames_info}` → `sbgames_info.tex` existe?
- [ ] `\includegraphics{Figuras/fig1.jpg}` → `Figuras/fig1.jpg` existe?
- [ ] `\bibliography{Referencias/referencias}` → `Referencias/referencias.bib` existe?

## Gate 2: Metadados (BLOQUEANTE)

- [ ] `sbgames_info.tex` não contém placeholders (`XXIII`, `Trilha`, `Cidade`)?
- [ ] `\title{...}` não está vazio ou placeholder?
- [ ] `\author{...}` preenchido com autores reais?

## Gate 3: Estrutura do Resumo (WARNING)

- [ ] Abstract contém: `\textbf{Introduction}`, `\textbf{Objective}`,
  `\textbf{Methodology}`, `\textbf{Results}`?
- [ ] Resumo contém: `\textbf{Introdução}`, `\textbf{Objetivo}`,
  `\textbf{Metodologia}`, `\textbf{Resultados}`?

## Gate 4: Consistência de Labels (WARNING)

- [ ] Todo `\ref{...}` tem `\label{...}` correspondente?
- [ ] Todo `\cite{...}` tem entrada no `referencias.bib`?

## Gate 5: Encoding (WARNING)

- [ ] Todos os `.tex` e `.sty` são UTF-8 válido?
- [ ] Nenhum `U+FFFD` no log da última compilação?

## Gate 6: Artefatos de Build (INFO)

- [ ] `build/` está no `.gitignore`?
- [ ] Último build gerou PDF sem erros?

---

## Como usar

```bash
./check.sh          # roda todos os gates, reporta status
./check.sh --strict # WARNINGs viram ERRORs (para CI)
```

## Níveis de Severidade

| Nível | Significado | Ação |
|-------|-------------|------|
| ERROR | Bloqueante | Corrija antes de compilar |
| WARNING | Atenção | Revise; build pode funcionar mas com problemas |
| INFO | Informativo | Boas práticas |
