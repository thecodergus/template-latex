# Partes/

Este diretório contém os arquivos `.tex` que são incluídos no documento
principal via `\input{}` ou `\include{}`.

## Como usar

1. Crie um arquivo `.tex` aqui, ex: `Partes/metodologia.tex`
2. Adicione `\input{Partes/metodologia}` no `Artigo.tex`
3. Compile normalmente: `./build.sh`

Nenhuma configuração adicional no `Tectonic.toml` é necessária —
o Tectonic segue a árvore AST do LaTeX automaticamente.

## Convenções

- Nomeie arquivos em minúsculas, sem espaços: `metodologia.tex`, `resultados.tex`
- Cada arquivo deve conter conteúdo autocontido (uma seção ou grupo de seções)
- Não inclua `\begin{document}` ou `\end{document}` — apenas o conteúdo
- Use `\input` (não `\include`) para evitar `\clearpage` desnecessário

## Exemplo

```latex
% Em Partes/metodologia.tex:
\section{Metodologia}
\subsection{Coleta de Dados}
Os dados foram coletados...
```
