# Systematic Reading Pipeline — Leitura Sistemática para Revisão de Literatura

Pipeline para processar artigos científicos de forma sistemática antes de
escrever a seção de trabalhos relacionados ou revisão de literatura.

## Fase 1: Extração em Lote

Converter PDFs para texto:
```bash
mkdir -p /tmp/papers_txt
for f in papers/*.pdf; do
  pdftotext "$f" "/tmp/papers_txt/$(basename $f .pdf).txt"
done
```

## Fase 2: Template P/S/R por Paper

Para cada paper, preencher:

| Campo | Descrição |
|-------|-----------|
| **P (Problema)** | Qual problema o paper resolve? |
| **S (Solução)** | Qual a abordagem/técnica proposta? |
| **R (Resultados)** | Quais os principais achados quantitativos? |
| **Dataset** | Quais dados usados para validação? |
| **Limitações** | Quais limitações os autores reconhecem? |
| **Gap** | O que o paper NÃO cobre que é relevante para nós? |

## Fase 3: Matriz Cross-Paper

Criar tabela comparativa:

| Paper | Problema | Método | Dataset | Métrica Principal | Limitação |
|-------|----------|--------|---------|-------------------|-----------|
| A | ... | ... | ... | ... | ... |
| B | ... | ... | ... | ... | ... |

## Fase 4: Gap Analysis

Identificar:
1. **O que todos cobrem:** fundamentos já estabelecidos
2. **O que ninguém cobre:** lacuna que seu trabalho preenche
3. **Contradições:** papers que discordam entre si
4. **Obsolescência:** técnicas que papers mais recentes mostram ser inferiores

## Fase 5: Síntese Narrativa

Organizar a revisão por temas, não por paper:
```
Tema 1: Abordagens baseadas em X
  - Paper A propôs... [resultados]
  - Paper B estendeu com... [resultados]
  - Limitação comum: ...

Tema 2: Abordagens baseadas em Y
  ...
```

## Fase 6: Geração de Tabela Comparativa LaTeX

```latex
\begin{table}[ht]
\centering
\caption{Comparação de trabalhos relacionados.}
\label{tab:relacionados}
\small
\begin{tabular}{p{2cm} p{2.5cm} p{2.5cm} p{2cm}}
\toprule
\textbf{Abordagem} & \textbf{Método} & \textbf{Métrica} & \textbf{Limitação} \\
\midrule
\cite{paperA} & X & Y & Z \\
\cite{paperB} & X' & Y' & Z' \\
\bottomrule
\end{tabular}
\end{table}
```

## Referência

Baseado no pipeline de leitura sistemática do sbc-article-writer skill.
