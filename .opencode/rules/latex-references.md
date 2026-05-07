---
globs:
  - "**/*.bib"
keywords:
  - referência
  - referencias
  - referências
  - bibliografia
  - bibliographystyle
  - bibtex
  - citação
  - \cite
  - citation
match: any
---

# Regras de Referências Bibliográficas

## Arquivo de Referências

As referências estão em `Referencias/referencias.bib`.
O estilo é definido por `\bibliographystyle{sbc}` (sbc.bst).

## Formato das Chaves

Use o formato `autor:ano` para chaves BibTeX:
```bibtex
@article{knuth:84,
  author = {Donald Knuth},
  ...
}
```

## Campos Obrigatórios por Tipo

### @article
- author, title, journal, year, volume, pages

### @inproceedings
- author, title, booktitle, year, pages

### @book
- author/editor, title, publisher, year

### @techreport
- author, title, institution, year

## Citações no Texto

```latex
\cite{knuth:84}                    % [Knuth 1984]
\cite{knuth:84,boulic:91}          % [Knuth 1984, Boulic 1991]
```

## Comandos no Documento

```latex
\bibliographystyle{sbc}                         % estilo
\bibliography{Referencias/referencias}           % arquivo .bib
```

## Troubleshooting

| Problema | Causa | Solução |
|----------|-------|---------|
| `Citation undefined` | Chave não encontrada no .bib | Verificar nome da chave |
| `?` no PDF em vez de [N] | BibTeX não rodou | `./build.sh` (Tectonic re-roda BibTeX automaticamente) |
| `Underfull \vbox` no .bbl | Entrada com formatação incomum | Warning inofensivo |
