---
globs:
  - "**/*.tex"
  - "**/*.bib"
keywords:
  - citar
  - citação
  - citações
  - cite
  - citacao
  - referência
  - referencias
  - bibliografia
  - validação
  - factual
  - verificar
  - fonte
tools:
  - write
  - edit
  - search
match: any
---

# Regras de Integridade de Citações

Baseado nas normas SBC de citação e no protocolo anti-alucinação.

## Proibições Absolutas

### 1. \citeonline{} PROIBIDO
Use APENAS `\cite{ref}` (entre parênteses).
```latex
% ERRADO:
\citeonline{autor} propuseram X...
% CORRETO:
X, proposto por \cite{autor}, ...
```

### 2. Referências Fictícias PROIBIDAS
NUNCA cite fontes não verificadas. Toda `\cite{chave}` deve ter entrada
correspondente em `Referencias/referencias.bib` e a referência deve ter
sido verificada contra o artigo original (via Semantic Scholar, arXiv ou
leitura direta do PDF).

### 3. Agrupamento de Citações ao Final EVITAR
```latex
% ERRADO (citações empilhadas no fim do parágrafo):
...o método proposto supera abordagens anteriores \cite{a,b,c,d,e}.

% CORRETO (citações distribuídas):
\cite{a} propuseram X. \cite{b} estenderam com Y. Nosso método
supera ambos em 15\% \cite{c} e reduz latência em 30\% \cite{d}.
```

## Verificação de Citações

Antes de entregar QUALQUER texto com citações:

1. **Cross-check .tex ↔ .bib:**
```bash
grep -oP '\\cite\{[^}]+\}' Artigo.tex | sed 's/\\cite{//;s/}//' | tr ',' '\n' | \
  while read key; do
    grep -q "{$key," Referencias/referencias.bib || echo "FANTASMA: $key"
  done
```

2. **Verificar ausência de \citeonline:**
```bash
grep -n '\\citeonline' Artigo.tex && echo "ERRO: citeonline encontrado" || echo "OK"
```

3. **Validar factualmente** — para claims sobre papers de terceiros, confirme
   no artigo original que a afirmação é correta. Consulte
   `.opencode/references/factual-validation-workflow.md`.

## Intenção de Citação por Seção

| Seção | Propósito da citação |
|-------|---------------------|
| Introdução / Trabalhos Relacionados | Contextualização e fundamentação teórica |
| Metodologia | Protocolos, datasets, ferramentas, métodos |
| Resultados / Discussão | Comparação de resultados, interpretações, implicações |

## Arquivos .md com Referências = SUSPEITOS

Arquivos markdown fornecidos pelo usuário com listas de referências são NÃO confiáveis.
Validar cada entrada contra Semantic Scholar ou o artigo original ANTES de usar.
