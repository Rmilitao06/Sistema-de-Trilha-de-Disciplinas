disciplina(banco_de_dados, obrigatoria, 6, 2).
disciplina(seguranca_da_informacao, obrigatoria, 4, 2).
disciplina(experiencia_criativa, obrigatoria, 6, 1).
disciplina(modelagem_fenomenos_fisicos, obrigatoria, 4, 3).
disciplina(natureza_discreta, obrigatoria, 4, 3).
disciplina(sistemas_ciberfisicos, obrigatoria, 4, 3).
disciplina(filosofia, obrigatoria, 4, 1).
disciplina(raciocinio_algoritmico, obrigatoria, 6, 1).
disciplina(big_data, obrigatoria, 4, 4).
disciplina(programacao_logica, obrigatoria, 4, 2).
disciplina(teologia, obrigatoria, 2, 4).
disciplina(etica, obrigatoria, 2, 2).
%materias futuras
disciplina(resolucao_problemas_grafos, obrigatoria, 6, 5).
disciplina(metodos_pesquisa_cientifica, obrigatoria, 4, 5).
disciplina(data_science, obrigatoria, 6, 7).
disciplina(cloud_computing, obrigatoria, 4, 7).
disciplina(arquitetura_software, obrigatoria, 4, 7).
%eletivas
disciplina(game_design, eletiva, 4, 6).
disciplina(ciencias_forences, eletiva, 4, 3).
disciplina(criacao_trilha_sonora_para_jogos, eletiva, 4, 6).

%1o Pre Requisito
prerequisito(resolucao_problemas_grafos, modelagem_fenomenos_fisicos).
prerequisito(modelagem_fenomenos_fisicos, natureza_discreta).
%2o Pre Requisito
prerequisito(data_science, big_data).
%3o Pre Requisito
prerequisito(arquitetura_software, raciocinio_algoritmico).

%---ALunos---
%Aluno com ritmo normal
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
%Aluno adiantado
cursou(carolina).
%Aluno Atrasado
cursou(santiago).
