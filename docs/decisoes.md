## Decisões de Modelagem

### Por que fatos separados para `prerequisito/2`?
Seguindo o princípio de Prolog: "muitos fatos pequenos é melhor que um fato com estrutura complexa". Cada `prerequisito(Disc, PreReq)` é independente, facilitando consultas e backtracking.

### Por que `findall/3` em vez de `setof/3`?
Para `disciplinas_liberadas` usamos `findall` porque queremos sempre uma lista (mesmo vazia), sem ordenação forçada. Para casos que exigem conjunto sem duplicatas, `setof/3` seria mais apropriado.

### Por que `forall/2` em `prerequisitos_ok`?
`forall(Condição, Ação)` verifica que uma propriedade é verdadeira para **todos** os pré-requisitos. Não coleta valores, apenas valida.

### Limite de 12 semestres em `trilha_valida`
Rede de segurança contra explosão combinatória, mesmo com dados corretos. Sem esse limite, buscas exaustivas podem travar o interpretador.

---
