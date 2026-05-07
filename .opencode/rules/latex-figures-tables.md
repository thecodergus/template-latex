---
globs:
  - "**/*.tex"
keywords:
  - figura
  - figuras
  - tabela
  - tabelas
  - table
  - figure
  - includegraphics
  - caption
  - label
  - legenda
  - gráfico
  - grafico
  - imagem
tools:
  - write
  - edit
match: any
---

# Regras para Figuras e Tabelas

## Legendas Analíticas e Autoexplicativas

Cada `\caption{}` deve:
1. **Descrever** sucintamente o que é apresentado
2. **Destacar** achados, tendências ou interpretações relevantes
3. **Definir** todas as abreviações, símbolos e unidades utilizadas
4. **Especificar** a fonte dos dados e eventuais adaptações

```latex
% ERRADO (legenda vaga):
\caption{Resultados do experimento.}

% CORRETO (legenda analítica):
\caption{Tempo médio de execução (ms) por tamanho de entrada (n=10^3 a 10^6).
Barras de erro indicam ±1 desvio padrão sobre 30 execuções. Nosso método (linha
sólida) reduz o tempo em 40\% comparado ao baseline \cite{autor:ano}.}
```

## Anotação Estatística Obrigatória

Para elementos com dados quantitativos, incluir na legenda:
- Descrição de barras de erro
- Intervalos de confiança
- Tamanho amostral (N)
- Testes estatísticos aplicados

## Referência no Texto ANTES da Figura/Tabela

```latex
% CORRETO:
...conforme a Figura~\ref{fig:resultados}, que mostra...
\begin{figure}[ht]
  ...
\end{figure}

% ERRADO:
\begin{figure}[ht]
  ...
\end{figure}
A Figura 1 mostra...
```

## Precisão Quantitativa em Tabelas

Células de resultados em tabelas comparativas devem conter valores numéricos
com contexto. EVITAR:

- `---` (sem explicação)
- `> manual` (vago)
- "Record" (sem qualificação)
- `< especializado` (impreciso)

```latex
% ERRADO:
Nossa abordagem & --- & > manual & Record \\

% CORRETO:
Nossa abordagem & gap $\approx -0{,}30\%$ (até 2000 clientes) &
2.3x mais rápido que template manual & 98.7\% acurácia \\
```

## Labels para Figuras e Tabelas

- Figuras: `\label{fig:nome}` — ex: `fig:arquitetura`, `fig:resultados`
- Tabelas: `\label{tab:nome}` — ex: `tab:comparativo`, `tab:relacionados`

Use nomes previsíveis que revisores esperam encontrar. Para tabela de trabalhos
relacionados, use `tab:relacionados` (não `tab:frameworks`).

## Formatos de Arquivo

- Figuras: JPG, PNG ou PDF
- Diretórios: `Figuras/` e `Tabelas/`
- Caption: Helvetica 10pt bold (definido pelo sbc-template.sty)
