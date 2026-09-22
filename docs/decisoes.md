## Decisões de Modelagem

### Por que fatos separados para `prerequisito/2`?
Seguindo o princípio de Prolog: "muitos fatos pequenos é melhor que um fato com estrutura complexa". Cada `prerequisito(Disc, PreReq)` é independente, facilitando consultas e backtracking.

### Por que `findall/3` em vez de `setof/3`?
Para `disciplinas_liberadas` usamos `findall` porque queremos sempre uma lista (mesmo vazia), sem ordenação forçada. Para casos que exigem conjunto sem duplicatas, `setof/3` seria mais apropriado.

### Por que `forall/2` em `prerequisitos_ok`?
`forall(Condição, Ação)` verifica que uma propriedade é verdadeira para **todos** os pré-requisitos. Não coleta valores, apenas valida.

### Limite de 12 semestres em `trilha_valida`
Rede de segurança contra explosão combinatória, mesmo com dados corretos. Sem esse limite, buscas exaustivas podem travar o interpretador.

## Uso de bagof/3

`disciplinas_pendentes_por_semestre/3` usa `bagof/3` em vez de
`findall/3` porque `Semestre` é uma variável livre no objetivo que não
está no modelo — `bagof/3` agrupa os resultados por essa variável,
retornando uma lista de pendências por semestre a cada solução, em vez
de misturar tudo numa única lista. Decorrência assumida: se o aluno não
tiver nenhuma pendência, o predicado falha (`false`) em vez de devolver
lista vazia, diferente de `findall/3`.

---
