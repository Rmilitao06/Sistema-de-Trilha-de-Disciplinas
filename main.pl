% ============================================================
% CAMADA 1: BASE DE FATOS
% ============================================================
% --- disciplinas ---
disciplina(banco_de_dados, obrigatoria, 6, 2).
disciplina(seguranca_da_informacao, obrigatoria, 4, 2).
disciplina(experiencia_criativa, obrigatoria, 6, 1).
disciplina(modelagem_fenomenos_fisicos, obrigatoria, 4, 4).
disciplina(natureza_discreta, obrigatoria, 4, 3).
disciplina(sistemas_ciberfisicos, obrigatoria, 4, 3).
disciplina(filosofia, obrigatoria, 4, 1).
disciplina(raciocinio_algoritmico, obrigatoria, 6, 1).
disciplina(big_data, obrigatoria, 4, 4).
disciplina(programacao_logica, obrigatoria, 4, 2).
disciplina(teologia, obrigatoria, 2, 4).
disciplina(etica, obrigatoria, 2, 2).
% materias futuras
disciplina(resolucao_problemas_grafos, obrigatoria, 6, 5).
disciplina(metodos_pesquisa_cientifica, obrigatoria, 4, 5).
disciplina(data_science, obrigatoria, 6, 7).
disciplina(cloud_computing, obrigatoria, 4, 7).
disciplina(arquitetura_software, obrigatoria, 4, 7).
% eletivas
disciplina(game_design, eletiva, 4, 6).
disciplina(ciencias_forenses, eletiva, 4, 3).
disciplina(criacao_trilha_sonora_para_jogos, eletiva, 4, 6).
% --- Pre Requisito ---
% 1o Pre Requisito
prerequisito(resolucao_problemas_grafos, modelagem_fenomenos_fisicos).
prerequisito(modelagem_fenomenos_fisicos, natureza_discreta).
% 2o Pre Requisito
prerequisito(data_science, big_data).
prerequisito(big_data, banco_de_dados).
prerequisito(banco_de_dados, raciocinio_algoritmico).
% 3o Pre Requisito
prerequisito(arquitetura_software, raciocinio_algoritmico).
% --- Alunos ---
% Aluno com ritmo normal (seguindo a grade)
cursou(henrique, banco_de_dados).
cursou(henrique, seguranca_da_informacao).
cursou(henrique, experiencia_criativa).
cursou(henrique, modelagem_fenomenos_fisicos).
cursou(henrique, natureza_discreta).
cursou(henrique, sistemas_ciberfisicos).
cursou(henrique, filosofia).
cursou(henrique, raciocinio_algoritmico).
cursou(henrique, big_data).
cursou(henrique, programacao_logica).
cursou(henrique, teologia).
cursou(henrique, etica).

% Aluno adiantado (esta adiante da grade)
cursou(carolina, banco_de_dados).
cursou(carolina, seguranca_da_informacao).
cursou(carolina, experiencia_criativa).
cursou(carolina, modelagem_fenomenos_fisicos).
cursou(carolina, natureza_discreta).
cursou(carolina, sistemas_ciberfisicos).
cursou(carolina, filosofia).
cursou(carolina, raciocinio_algoritmico).
cursou(carolina, big_data).
cursou(carolina, programacao_logica).
cursou(carolina, teologia).
cursou(carolina, etica).
% cursos avancados
cursou(carolina, resolucao_problemas_grafos).
cursou(carolina, metodos_pesquisa_cientifica).

% Aluno atrasado (ficou para tras)
cursou(santiago, banco_de_dados).
cursou(santiago, seguranca_da_informacao).
cursou(santiago, experiencia_criativa).
cursou(santiago, filosofia).
cursou(santiago, raciocinio_algoritmico).
cursou(santiago, etica).

% ============================================================
% CAMADA 2: REGRAS DE ELEGIBILIDADE
% ============================================================
aluno_existe(Aluno) :-
    atom(Aluno),
    cursou(Aluno, _).
prerequisitos_ok(Aluno, Disciplina) :-
    aluno_existe(Aluno),
    disciplina(Disciplina, _, _, _),
    forall(
        prerequisito(Disciplina, PreReq),
        cursou(Aluno, PreReq)
    ).

pode_cursar(Aluno, Disciplina) :-
    aluno_existe(Aluno),
    disciplina(Disciplina, _, _, _),
    prerequisitos_ok(Aluno, Disciplina),
    \+ cursou(Aluno, Disciplina).

disciplinas_liberadas(Aluno, Lista) :-
    aluno_existe(Aluno),
    findall(
        Disciplina,
        pode_cursar(Aluno, Disciplina),
        Lista
    ).

disciplinas_pendentes(Aluno, Lista) :-
    aluno_existe(Aluno),
    findall(
        Disciplina,
        (
            disciplina(Disciplina, obrigatoria, _, _),
            \+ cursou(Aluno, Disciplina)
        ),
        Lista
    ).

creditos_cursados(Aluno, Total) :-
    aluno_existe(Aluno),
    findall(
        Creditos,
        (
            cursou(Aluno, Disciplina),
            disciplina(Disciplina, _, Creditos, _)
        ),
        ListaCreditos
    ),
    sum_list(ListaCreditos, Total).

% ============================================================
% CAMADA 3: FECHO TRANSITIVO E GERACAO DE TRILHAS
% ============================================================
prerequisito_transitivo(Disciplina, Ancestral) :-
    prerequisito_transitivo(Disciplina, Ancestral, [Disciplina]).

prerequisito_transitivo(Disciplina, Ancestral, _Visitados) :-
    prerequisito(Disciplina, Ancestral).

prerequisito_transitivo(Disciplina, Ancestral, Visitados) :-
    prerequisito(Disciplina, Intermediaria),
    \+ member(Intermediaria, Visitados),
    prerequisito_transitivo(Intermediaria, Ancestral, [Intermediaria | Visitados]).

existe_ciclo(Disciplina) :-
    prerequisito_transitivo(Disciplina, Disciplina).

trilha_valida(Aluno, MaxCreditosPorSemestre, Trilha) :-
    disciplinas_pendentes(Aluno, Pendentes),
    findall(D, cursou(Aluno, D), JaConcluidas),
    LimiteSemestres = 12,
    gerar_trilha(Pendentes, JaConcluidas, MaxCreditosPorSemestre,
                  LimiteSemestres, Trilha).
