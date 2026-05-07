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
  - chave
  - entrada
  - bib
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
  title = {Literate Programming},
  journal = {The Computer Journal},
  year = {1984},
  volume = {27},
  pages = {97--111}
}
```

## Campos Obrigatórios por Tipo

### @article
author, title, journal, year, volume, pages

### @inproceedings
author, title, booktitle, year, pages

### @book
author/editor, title, publisher, year

### @techreport
author, title, institution, year

### @misc (somente quando não há tipo específico)
author, title, year, howpublished, note/url

## Citações no Texto

```latex
\cite{knuth:84}                    % [Knuth 1984]
\cite{knuth:84,boulic:91}          % [Knuth 1984, Boulic 1991]
```

**PROIBIDO:** `\citeonline{ref}` não existe no estilo SBC.

## Comandos no Documento

```latex
\bibliographystyle{sbc}                         % estilo
\bibliography{Referencias/referencias}           % arquivo .bib
```

## Verificação de Consistência .tex ↔ .bib

Antes de finalizar qualquer entrega:

1. Extraia chaves de `\cite{}`:
```bash
grep -oP '\\cite\{[^}]+\}' Artigo.tex | sed 's/\\cite{//;s/}//' | tr ',' '\n' | sort -u
```

2. Valide cada chave contra o .bib:
```bash
grep "{$key," Referencias/referencias.bib
```

3. Adicione entradas faltantes ao .bib antes de concluir.

4. Para novas referências, busque dados bibliográficos precisos (autor, título,
   ano, DOI) via Semantic Scholar ou web_search nos artigos originais — NUNCA
   invente metadados.

## Troubleshooting

| Problema | Causa | Solução |
|----------|-------|---------|
| `Citation undefined` | Chave não encontrada no .bib | Verificar nome da chave; adicionar entrada |
| `?` no PDF em vez de [N] | BibTeX não rodou | `./build.sh` (Tectonic re-roda BibTeX automaticamente) |
| `Underfull \vbox` no .bbl | Entrada com formatação incomum | Warning inofensivo |
| Entrada duplicada | Mesma chave em dois lugares | Remover duplicata; usar chave única |

## Referências Não Verificáveis

Se não for possível verificar existência ou conteúdo de uma referência:
1. Sinalize explicitamente a limitação no texto
2. NÃO use a referência como base para afirmações críticas
3. Prefira substituir por fonte verificável
