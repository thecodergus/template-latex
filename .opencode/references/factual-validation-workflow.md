# Factual Validation Workflow — Validação de Afirmações e Referências

Protocolo para validar claims factuais em artigos acadêmicos antes da entrega.
Adaptado do sbc-article-writer skill.

## Quando Executar

Após escrever QUALQUER seção que:
- Resume artigos de terceiros (revisão de literatura, trabalhos relacionados)
- Faz claims numéricos baseados em fontes externas
- Cita resultados de outros autores
- Usa referências fornecidas em arquivos auxiliares (.md, .txt)

## Pipeline de Validação

### 1. Extração dos PDFs de Referência

Converta PDFs fornecidos pelo usuário para texto puro:
```bash
pdftotext arquivo.pdf arquivo.txt
```

### 2. Confronto de Claims

Para cada afirmação no texto que referencia um paper:
```bash
grep -i "termo chave" arquivo.txt | head -20
```

Verifique:
- O valor numérico citado existe no paper?
- O método é atribuído ao paper correto?
- O ano, venue e autores conferem?

### 3. Verificação Bibliográfica Online

Use Semantic Scholar para confirmar metadados:
```
mcp_semantic_scholar_search_paper(query="título exato do artigo")
mcp_semantic_scholar_get_paper(paper_id="...")
mcp_semantic_scholar_get_citation(paper_id="...", format="bibtex")
```

Alternativa: web_search com título exato + autores.

### 4. Correção Imediata

Se encontrar discrepância:
- Corrija o `.tex` imediatamente
- Atualize a entrada `.bib` com metadados verificados
- Documente a correção

## Checklist de Validação

Antes de entregar, confirme:
- [ ] Todos os claims numéricos foram verificados nos PDFs fonte
- [ ] Nomes de métodos estão atribuídos aos papers corretos
- [ ] Metadados de cada entrada .bib verificados (autor, título, ano, venue)
- [ ] Nenhuma referência fictícia (chave sem entrada no .bib)
- [ ] Claims do feedback do professor também validados (podem conter erros)
- [ ] Arquivos auxiliares .md tratados como suspeitos e validados

## Sinais de Alerta

- Referência com ano, autores ou venue que "parecem plausíveis" mas não foram verificados
- Arquivo .md do usuário listando referências com formatação inconsistente
- Claims como "10x mais eficiente", "80% elite" sem fonte rastreável
- Paper citado como fonte de método que ele apenas referencia, não introduz

## Referência

Baseado no protocolo de validação factual do sbc-article-writer skill e
no checklist de 7 modos de falha de Lu et al. (2026), *Nature* 651:914-919.
