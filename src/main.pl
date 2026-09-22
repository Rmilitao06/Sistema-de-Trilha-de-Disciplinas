% ============================================================
% MAIN: CONSULTAS DE DEMONSTRACAO (demo/0)
% ============================================================
% Este arquivo nao define logica nova. Ele so CHAMA os
% predicados ja definidos nas Camadas 1, 2 e 3 e imprime os
% resultados de forma legivel, na ordem exigida pela Secao 6:
% "predicados de demonstracao que exercitam, em sequencia, as
% tres camadas com pelo menos um dos alunos de teste."
%
% Para carregar junto com o restante do projeto no SWISH, cole
% este bloco depois dos arquivos/secoes das Camadas 1, 2 e 3.
 
demo :-
    nl,
    format("============================================~n"),
    format(" DEMO -- SISTEMA DE TRILHA DE DISCIPLINAS~n"),
    format("============================================~n"),
    demo_camada1,
    demo_camada2,
    demo_camada3,
    demo_casos_de_borda,
    nl,
    format("============================================~n"),
    format(" FIM DA DEMO~n"),
    format("============================================~n").
 
 
% ------------------------------------------------------------
% CAMADA 1: consulta simples sobre os fatos
% ------------------------------------------------------------
% Requisito da Secao 8 (Camada 1): "uma consulta simples que
% lista todas as disciplinas de um semestre sugerido
% especifico." Usamos findall/3 porque so precisamos de UMA
% lista com todos os resultados, nao de verificar uma
% propriedade (isso seria papel do forall/2) nem de exigir
% ordenacao/unicidade (isso seria papel do setof/3).
demo_camada1 :-
    nl,
    format("--- CAMADA 1: Base de Fatos ---~n"),
    Semestre = 2,
    findall(D, disciplina(D, _, _, Semestre), Disciplinas),
    format("Disciplinas do semestre ~w: ~w~n", [Semestre, Disciplinas]).
 
 
% ------------------------------------------------------------
% CAMADA 2: regras de elegibilidade
% ------------------------------------------------------------
% Requisito da Secao 8 (Camada 2): disciplinas_liberadas/2 e
% disciplinas_pendentes/2 para pelo menos 2 alunos, com
% resultados diferentes; e um caso em que \+ cursou(...) muda
% o resultado de pode_cursar/2.
demo_camada2 :-
    nl,
    format("--- CAMADA 2: Regras de Elegibilidade ---~n"),
 
    % henrique (ritmo normal) e santiago (atrasado): mostrar
    % que os resultados sao diferentes entre alunos diferentes.
    creditos_cursados(henrique, CreditosHenrique),
    format("Creditos cursados (henrique): ~w~n", [CreditosHenrique]),
    disciplinas_liberadas(henrique, LiberadasHenrique),
    format("Disciplinas liberadas (henrique): ~w~n", [LiberadasHenrique]),
    disciplinas_pendentes(henrique, PendentesHenrique),
    format("Disciplinas pendentes (henrique): ~w~n", [PendentesHenrique]),
 
    creditos_cursados(santiago, CreditosSantiago),
    format("Creditos cursados (santiago): ~w~n", [CreditosSantiago]),
    disciplinas_liberadas(santiago, LiberadasSantiago),
    format("Disciplinas liberadas (santiago): ~w~n", [LiberadasSantiago]),
    disciplinas_pendentes(santiago, PendentesSantiago),
    format("Disciplinas pendentes (santiago): ~w~n", [PendentesSantiago]),
 
    % Caso em que \+ cursou(...) e decisivo: santiago ainda nao
    % cursou big_data (mas ja tem o pre-requisito dela pronto),
    % enquanto henrique ja cursou. Muda o historico, muda o
    % resultado de pode_cursar/2.
    ( pode_cursar(henrique, big_data)
    -> format("pode_cursar(henrique, big_data): true (inesperado)~n")
    ;  format("pode_cursar(henrique, big_data): false (ja cursou)~n")
    ),
    ( pode_cursar(santiago, big_data)
    -> format("pode_cursar(santiago, big_data): true (nao cursou, prereq ok)~n")
    ;  format("pode_cursar(santiago, big_data): false (inesperado)~n")
    ).
 
 
% ------------------------------------------------------------
% CAMADA 3: fecho transitivo, ciclo e trilhas
% ------------------------------------------------------------
% Requisito da Secao 8 (Camada 3): prerequisito_transitivo/2 na
% cadeia de profundidade >= 3; uma trilha_valida/3 completa
% para um aluno; multiplas trilhas via findall.
demo_camada3 :-
    nl,
    format("--- CAMADA 3: Fecho Transitivo e Trilhas ---~n"),
 
    % Cadeia de profundidade 3: data_science -> big_data ->
    % banco_de_dados -> raciocinio_algoritmico
    ( prerequisito_transitivo(data_science, raciocinio_algoritmico)
    -> format("prerequisito_transitivo(data_science, raciocinio_algoritmico): true~n")
    ;  format("prerequisito_transitivo(data_science, raciocinio_algoritmico): false (inesperado)~n")
    ),
 
    % Base de fatos real nao deve ter ciclos.
    ( existe_ciclo(data_science)
    -> format("existe_ciclo(data_science): true (base malformada!)~n")
    ;  format("existe_ciclo(data_science): false (esperado)~n")
    ),
 
    % UMA trilha valida para o santiago (o mais atrasado, entao
    % o caso mais interessante de ver formar). once/1 pega so a
    % primeira solucao, sem precisar enumerar todas.
    ( once(trilha_valida(santiago, 20, TrilhaSantiago))
    -> format("Uma trilha valida para santiago (max 20 creditos/sem): ~w~n", [TrilhaSantiago])
    ;  format("Nao foi possivel gerar trilha para santiago com esse limite.~n")
    ),
 
    % MULTIPLAS trilhas validas, via findall. Trilhas curtas
    % podem ter varias combinacoes possiveis; limitamos a
    % quantidade mostrada para nao poluir a saida. Não testar com o santiago, porque ele tem muitas pendencias e o resultado seria enorme.
    findall(T, trilha_valida(carolina, 20, T), TodasAsTrilhas),
    length(TodasAsTrilhas, QuantidadeTrilhas),
    format("Trilhas validas para carolina (poucas pendencias): ~w~n", [QuantidadeTrilhas]),
    forall(member(Trilha, TodasAsTrilhas), format("  ~w~n", [Trilha])).
 
 
% ------------------------------------------------------------
% CASOS DE BORDA: robustez (Secao 6)
% ------------------------------------------------------------
% "Consultas com aluno ou disciplina inexistente nao podem
% lancar uma excecao nao tratada, devem falhar de forma limpa
% (false) ou informar uma mensagem clara." Aqui usamos
% if-then-else para transformar o false em mensagem legivel,
% em vez de deixar a demo simplesmente parar ali.
demo_casos_de_borda :-
    nl,
    format("--- CASOS DE BORDA (robustez) ---~n"),
 
    ( disciplinas_liberadas(carlos, _)
    -> format("disciplinas_liberadas(carlos, _): retornou algo (inesperado)~n")
    ;  format("disciplinas_liberadas(carlos, _): false, como esperado (aluno inexistente)~n")
    ),
 
    ( pode_cursar(henrique, quimica)
    -> format("pode_cursar(henrique, quimica): true (inesperado)~n")
    ;  format("pode_cursar(henrique, quimica): false, como esperado (disciplina inexistente)~n")
    ).