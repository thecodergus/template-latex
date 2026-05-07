---
globs:
  - "**/*.sty"
  - "**/*.cls"
  - "**/*.tex"
keywords:
  - estilo
  - style
  - template
  - formatação
  - fancyhdr
  - cabeçalho
  - header
match: any
---

# Regras de Estilo LaTeX

## Template SBC/SBGames

O projeto usa estilo SBC (sbc-template.sty) com headers SBGames (sbgames.sty).

### Arquivos de Estilo

| Arquivo | Função | Modificar? |
|---------|--------|-----------|
| `sbc-template.sty` | Geometria, fontes, seções, caption | NÃO — é o template oficial SBC |
| `sbgames.sty` | Headers com metadados do evento | Apenas se necessário |
| `sbc.bst` | Formato bibliográfico | NÃO — é o padrão SBC |
| `caption2.sty` | Compatibilidade caption | NÃO — legado |

### Blank Lines em Fancyhdr (CRÍTICO)

**NUNCA** coloque linhas em branco dentro de `\fancyhead{}` ou `\fancyfoot{}`.
O XeTeX interpreta linha em branco como `\par` e causa:
```
Paragraph ended before \f@nch@fancyhf was complete
```

Sempre use `%` (comentário vazio) em vez de linha em branco:
```latex
% CORRETO:
\fancyhead[R]{
    {\scriptsize
        %
        \begin{tabular}[t]{@{}r@{}}
            Trilha: \gettrilha
        \end{tabular}
    }
}

% ERRADO:
\fancyhead[R]{
    {\scriptsize

        \begin{tabular}[t]{@{}r@{}}
            Trilha: \gettrilha
        \end{tabular}
    }
}
```

### Metadados do Evento

Editar `sbgames_info.tex` para cada artigo:
```latex
\edicao{XXIII}
\trilha{Computação}
\ano{2026}
\local{Cidade - UF}
```

### Pacotes Pdflatex

`\usepackage[utf8]{inputenc}` e `\usepackage[T1]{fontenc}` são ignorados
pelo XeTeX. Geram warnings mas NÃO causam erros. Podem permanecer.
