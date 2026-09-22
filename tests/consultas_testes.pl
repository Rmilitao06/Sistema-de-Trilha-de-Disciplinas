% --- testes ---

testar_tudo :-
    teste_aluno_sem_historico,
    teste_alunos_existentes,
    teste_creditos,
    teste_trilha.

%1o Teste: Verifica aluno sem historico e se gera pendencia para o aluno inesistente.
teste_aluno_sem_historico :-
    writeln('\n--- Aluno sem historico ---'),
    (   \+ aluno_existe(joao) 
    ->  writeln('sistema rejeitou o aluno inexistente.')
    ;   writeln('sistema achou que o aluno existe.')
    ),
    (   \+ disciplinas_pendentes(joao, _)
    ->  writeln('nao gerou pendencias para aluno invalido.')
    ;   writeln('gerou pendencias para aluno invalido.')
    ).

%2o Teste: verifica os alunos, mostra as disciplinas liberadas para o Henrique
%¨mostra as disciplinas pendentes para a Carolina e para o Santiago
teste_alunos_existentes :-
    writeln('\nVerificacao de alunos existentes'),
    
    disciplinas_liberadas(henrique, Lib_Henrique),
    format('disciplinas liberadas para Henrique: ~w~n', [Lib_Henrique]),
    
    disciplinas_pendentes(carolina, Pend_Carolina),
    format('disciplinas pendentes para Carolina: ~w~n', [Pend_Carolina]),
    
    disciplinas_pendentes(santiago, Pend_Santiago),
    format('disciplinas pendentes para Santiago: ~w~n', [Pend_Santiago]).

%3o Teste: Conta os creditos dos alunos
teste_creditos :-
    creditos_cursados(henrique, Cred_H),
    creditos_cursados(santiago, Cred_S),
    format('Henrique possui ~w creditos.~n', [Cred_H]),
    format('Santiago possui ~w creditos.~n', [Cred_S]),
    %compara a quantidade de creditos de cada um
    %Santiago esta atrasado, entao deve ter menos creditos
    (   Cred_H > Cred_S 
    ->  writeln('Henrique tem mais creditos que Santiago.')
    ;   writeln('Logica dos creditos incorreta.')
    ).

%4o Teste: Geracao de Trilha Valida
teste_trilha :-
    (   trilha_valida(santiago, 10, Trilha)
    ->  writeln('Trilha gerada com sucesso'),
        imprimir_trilha(Trilha,1)
    ;   writeln('nao foi possivel gerar a trilha')
    ).

%para imprimir a trilha de forma mais organizada
imprimir_trilha([], _).
imprimir_trilha([Semestre | Resto], Num) :-
    format('Semestre ~w: ~w~n', [Num, Semestre]),
    Prox is Num + 1,
    imprimir_trilha(Resto, Prox).
