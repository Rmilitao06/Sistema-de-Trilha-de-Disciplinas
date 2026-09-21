% ============================================================
% CAMADA 3: FECHO TRANSITIVO E GERACAO DE TRILHAS
% ============================================================

% fecho transitivo

prerequisito_transitivo(Disciplina, Ancestral) :-
    prerequisito_transitivo(Disciplina, Ancestral, [Disciplina]).

prerequisito_transitivo(Disciplina, Ancestral, _Visitados) :-
    prerequisito(Disciplina, Ancestral).

prerequisito_transitivo(Disciplina, Ancestral, Visitados) :-
    prerequisito(Disciplina, Intermediaria),
    \+ member(Intermediaria, Visitados),
    prerequisito_transitivo(
        Intermediaria,
        Ancestral,
        [Intermediaria | Visitados]
    ).

% deteccao de ciclo

existe_ciclo(Disciplina) :-
    ciclo_a_partir_de(Disciplina, Disciplina, [Disciplina]).

ciclo_a_partir_de(Atual, Alvo, _) :-
    prerequisito(Atual, Alvo).

ciclo_a_partir_de(Atual, Alvo, Visitados) :-
    prerequisito(Atual, Proximo),
    Proximo \= Alvo,
    \+ member(Proximo, Visitados),
    ciclo_a_partir_de(
        Proximo,
        Alvo,
        [Proximo | Visitados]
    ).

% trilha valida

trilha_valida(Aluno, MaxCreditosPorSemestre, Trilha) :-
    disciplinas_pendentes(Aluno, Pendentes),
    findall(D, cursou(Aluno, D), JaConcluidas),
    LimiteSemestres = 12,
    gerar_trilha(
        Pendentes,
        JaConcluidas,
        MaxCreditosPorSemestre,
        LimiteSemestres,
        Trilha
    ).

% geracao da trilha

% caso base: quando nao existem mais disciplinas pendentes, a trilha terminou

gerar_trilha([], _, _, _, []).

% gera um semestre e continua gerando os proximos

gerar_trilha(
    Pendentes,
    Concluidas,
    MaxCreditos,
    Limite,
    [Semestre | Resto]
) :-
    Limite > 0,

    disciplinas_disponiveis(
        Pendentes,
        Concluidas,
        Disponiveis
    ),

    escolher_semestre(
        Disponiveis,
        MaxCreditos,
        Semestre
    ),

    Semestre \= [],

    remover_disciplinas(
        Pendentes,
        Semestre,
        NovosPendentes
    ),

    append(
        Concluidas,
        Semestre,
        NovasConcluidas
    ),

    NovoLimite is Limite - 1,

    gerar_trilha(
        NovosPendentes,
        NovasConcluidas,
        MaxCreditos,
        NovoLimite,
        Resto
    ).

% disciplinas disponiveis

% ve quais disciplinas pendentes ja podem ser cursadas

disciplinas_disponiveis([], _, []).

disciplinas_disponiveis(
    [Disciplina | Resto],
    Concluidas,
    Disponiveis
) :-
    disciplinas_disponiveis(
        Resto,
        Concluidas,
        Outras
    ),

    (
        prerequisitos_trilha_ok(
            Disciplina,
            Concluidas
        )
        ->
        Disponiveis = [Disciplina | Outras]
        ;
        Disponiveis = Outras
    ).

% verificacao dos pre-requisitos

% verifica os pre-requisitos diretos e indiretos.

prerequisitos_trilha_ok(
    Disciplina,
    Concluidas
) :-
    forall(
        prerequisito_transitivo(
            Disciplina,
            PreReq
        ),
        member(
            PreReq,
            Concluidas
        )
    ).

% escolha das disciplinas do semestre

escolher_semestre(
    Disponiveis,
    MaxCreditos,
    Semestre
) :-
    escolher_disciplinas(
        Disponiveis,
        MaxCreditos,
        Semestre
    ),

    Semestre \= [].

% escolha das disciplinas

% quando nao existe mais disciplinas para analisar

escolher_disciplinas(
    [],
    _,
    []
).

% escolhe a disciplina atual para o semestre, desde que ela caiba no limite de creditos

escolher_disciplinas(
    [Disciplina | Resto],
    MaxCreditos,
    [Disciplina | Escolhidas]
) :-
    disciplina(
        Disciplina,
        _,
        Creditos,
        _
    ),

    MaxCreditos >= Creditos,
    NovoMax is MaxCreditos - Creditos,

    escolher_disciplinas(
        Resto,
        NovoMax,
        Escolhidas
    ).


% caso a disciplina atual nao seja escolhida, continua analisando as demais
% essa segunda possibilidade é importante para o backtracking e para gerar diferentes trilhas

escolher_disciplinas(
    [_ | Resto],
    MaxCreditos,
    Escolhidas
) :-
    escolher_disciplinas(
        Resto,
        MaxCreditos,
        Escolhidas
    ).

% remocao das disciplinas

% quando nao ha mais disciplinas escolhidas para remover, retorna o restante das disciplinas pendentes

remover_disciplinas(
    Pendentes,
    [],
    Pendentes
).


% remove uma disciplina escolhida da lista de pendentes

remover_disciplinas(
    Pendentes,
    [Disciplina | Resto],
    NovosPendentes
) :-
    select(
        Disciplina,
        Pendentes,
        Restantes
    ),

    remover_disciplinas(
        Restantes,
        Resto,
        NovosPendentes
    ).