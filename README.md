# Sistema de Trilha de Disciplinas (Curriculum Advisor) - Prolog

## 📋 Descrição do Projeto

Este projeto implementa um **Conselheiro Curricular** (Curriculum Advisor) em Prolog que simula a grade curricular de um curso universitário e responde perguntas sobre elegibilidade de disciplinas e caminhos viáveis até a formatura.

O sistema é capaz de:
- Consultar todas as disciplinas de um semestre específico
- Verificar quais disciplinas um aluno pode cursar agora (baseado em pré-requisitos)
- Listar disciplinas pendentes (obrigatórias ainda não cursadas)
- Calcular créditos cursados por um aluno
- **Gerar trilhas válidas** (sequências de semestres) respeitando pré-requisitos e limite de créditos por semestre

---

## 🎯 Objetivos de Aprendizagem

Ao concluir este trabalho, consolidamos os fundamentos de programação lógica:

- ✅ Modelar conhecimento declarativo via **fatos e regras**
- ✅ Usar **recursão** para calcular fecho transitivo de pré-requisitos
- ✅ Aplicar **backtracking** para gerar soluções com múltiplas restrições
- ✅ Dominar **negação por falha** (`\+`) e predicados de agregação (`findall`, `bagof`, `setof`)
- ✅ Reconhecer e evitar **armadilhas clássicas** de Prolog (loops infinitos, explosão combinatória)

---

## 🏗️ Estrutura do Projeto - As 3 Camadas

O código está organizado em **três camadas de complexidade crescente**, cada uma construída sobre a anterior:

### **Camada 1: Base de Fatos**
Define o conhecimento estático do sistema (o que existe).

**Predicados:**
- `disciplina(Nome, Tipo, Créditos, SemestreSugerido)` — Cataloga todas as disciplinas
- `prerequisito(Disciplina, Pré-requisito)` — Relacionamentos de dependência
- `cursou(Aluno, Disciplina)` — Histórico acadêmico de cada aluno

**Dados cadastrados:**
- **20+ disciplinas** cobrindo pelo menos 6 semestres sugeridos
- **3+ eletivas** incluídas na grade
- **Cadeias de pré-requisitos com profundidade ≥ 3** para exercitar recursão

### **Camada 2: Regras de Elegibilidade**
Define o que é permitido agora (regras diretas, sem olhar para o futuro).

**Predicados:**
- `prerequisitos_ok(Aluno, Disciplina)` — Verifica se todos os pré-requisitos diretos foram cursados
- `pode_cursar(Aluno, Disciplina)` — Elegível E ainda não cursada (usa negação por falha)
- `disciplinas_liberadas(Aluno, Lista)` — Todas as disciplinas que o aluno pode cursar agora
- `disciplinas_pendentes(Aluno, Lista)` — Todas as obrigatórias ainda não cursadas
- `creditos_cursados(Aluno, Total)` — Soma dos créditos já completados

**Técnicas utilizadas:**
- Negação por falha (`\+`)
- Agregação com `findall/3` e `forall/2`

### **Camada 3: Fecho Transitivo e Geração de Trilhas**
Define o que é possível ao longo do tempo (recursão + busca inteligente).

**Predicados:**
- `prerequisito_transitivo(Disciplina, Ancestral)` — Fecho transitivo (pré-requisitos diretos E indiretos)
- `existe_ciclo(Disciplina)` — Detecta ciclos na base de pré-requisitos
- `trilha_valida(Aluno, MaxCreditosPorSemestre, Trilha)` — Gera sequências de semestres válidas via backtracking

**Características:**
- Respeita pré-requisitos transitivos
- Limita créditos por semestre
- Implementa limite de segurança (máx. 12 semestres simulados) contra explosão combinatória
- Permite enumerar múltiplas trilhas via `findall/bagof`

---

## 📊 Base de Dados Atual

### Disciplinas Cadastradas (20)

| Semestre | Disciplina | Tipo | Créditos |
|----------|-----------|------|----------|
| **1** | Experiência Criativa | Obrigatória | 6 |
| **1** | Filosofia | Obrigatória | 4 |
| **1** | Raciocínio Algorítmico | Obrigatória | 6 |
| **2** | Banco de Dados | Obrigatória | 6 |
| **2** | Segurança da Informação | Obrigatória | 4 |
| **2** | Programação Lógica | Obrigatória | 4 |
| **2** | Ética | Obrigatória | 2 |
| **3** | Modelagem de Fenômenos Físicos | Obrigatória | 4 |
| **3** | Natureza Discreta | Obrigatória | 4 |
| **3** | Sistemas Ciberfísicos | Obrigatória | 4 |
| **3** | Ciências Forenses | Eletiva | 4 |
| **4** | Big Data | Obrigatória | 4 |
| **4** | Teologia | Obrigatória | 2 |
| **5** | Resolução de Problemas com Grafos | Obrigatória | 6 |
| **5** | Métodos de Pesquisa Científica | Obrigatória | 4 |
| **6** | Game Design | Eletiva | 4 |
| **6** | Criação de Trilha Sonora para Jogos | Eletiva | 4 |
| **7** | Data Science | Obrigatória | 6 |
| **7** | Cloud Computing | Obrigatória | 4 |
| **7** | Arquitetura de Software | Obrigatória | 4 |

### Cadeias de Pré-requisitos

1. **Resolução de Problemas com Grafos** ← Modelagem de Fenômenos Físicos ← Natureza Discreta (profundidade 3)
2. **Data Science** ← Big Data (profundidade 2)
3. **Arquitetura de Software** ← Raciocínio Algorítmico (profundidade 2)

### Alunos de Teste

| Aluno | Perfil | Disciplinas Cursadas | Créditos |
|-------|--------|----------------------|----------|
| **Henrique** | Ritmo Normal | 12 disciplinas (até semestre 4) | 44 |
| **Carolina** | Adiantado | 14 disciplinas (incluindo semestres 5) | 62 |
| **Santiago** | Atrasado | 7 disciplinas (faltam semestres 3, 4, 5) | 31 |

---

## 💻 Como Usar

### Pré-requisitos
- **SWI-Prolog** instalado (gratuito, multiplataforma)
- Nenhuma biblioteca externa necessária

### Executar o Projeto

```bash
# Abrir SWI-Prolog
swipl

% Carregar o arquivo principal
?- consult('main.pl').

% Executar testes básicos
?- demo.
```

### Exemplos de Consultas

#### **Camada 1: Base de Fatos**
```prolog
% Listar todas as disciplinas do semestre 2
?- disciplina(D, _, _, 2), writeln(D), fail.

% Verificar pré-requisitos diretos de uma disciplina
?- prerequisito(data_science, X), writeln(X), fail.
```

#### **Camada 2: Elegibilidade**
```prolog
% Disciplinas que Henrique pode cursar agora
?- disciplinas_liberadas(henrique, Lista), writeln(Lista).

% Disciplinas obrigatórias que faltam a Santiago
?- disciplinas_pendentes(santiago, Pendentes), writeln(Pendentes).

% Créditos que Carolina já cursou
?- creditos_cursados(carolina, Total), format('Total: ~w~n', [Total]).

% Verificar se Henrique pode cursar Resolução de Problemas com Grafos
?- pode_cursar(henrique, resolucao_problemas_grafos).
```

#### **Camada 3: Fecho Transitivo e Trilhas**
```prolog
% Encontrar UMA trilha válida para Henrique (máx. 20 créditos/semestre)
?- trilha_valida(henrique, 20, Trilha), writeln(Trilha).

% Enumerar MÚLTIPLAS trilhas para Carolina
?- findall(T, trilha_valida(carolina, 20, T), Trilhas), length(Trilhas, N), 
   format('Encontradas ~w trilhas~n', [N]).

% Verificar se existe ciclo na cadeia de pré-requisitos
?- existe_ciclo(data_science).  % false = sem ciclo
```

---

## ⚠️ Armadilhas Evitadas

| Armadilha | Como Evitamos |
|-----------|---------------|
| **Uso de `\+` com variável livre** | Sempre instancia Aluno/Disciplina antes de usar negação |
| **Loops infinitos em recursão** | `prerequisito_transitivo` tem caso base claro; ciclos detectáveis |
| **Explosão combinatória** | Limite máximo de semestres simulados (12) em `trilha_valida` |
| **Uso desnecessário de assert/retract** | Código é puro, usa apenas unificação e backtracking |
| **findall com duplicatas indevidas** | Validação de agregação apropriada a cada contexto |

---

## 📁 Estrutura de Arquivos

Sistema-de-Trilha-de-Disciplinas/
├── src/
│ ├── curriculum.pl `Camada 1`
│ ├── elegibilidade.pl `Camada 2`
│ ├── trilhas.pl `Camada 3`
│ └── main.pl `Arquivo Principal`
├── tests/
│ └── consultas_teste.pl `Consultas e Testes`
├── docs/
│ └── decisoes.md `Decisões de Modelagem`
└── README.md `Este Arquivo`

---

## 🔍 Testes Implementados

O projeto atende aos casos de teste obrigatórios:

- ✅ **Camada 1**: Consultas sobre disciplinas por semestre
- ✅ **Camada 2**: `disciplinas_liberadas` e `disciplinas_pendentes` para múltiplos alunos
- ✅ **Camada 2**: Negação por falha decisiva em `pode_cursar`
- ⏳ **Camada 3**: Fecho transitivo com profundidade ≥ 3 (em desenvolvimento)
- ⏳ **Camada 3**: Geração de trilhas válidas (em desenvolvimento)
- ⏳ **Camada 3**: Detecção e teste de ciclos (em desenvolvimento)

---

## 🚀 Próximas Etapas

- [ ] Implementar `prerequisito_transitivo/2` com recursão bem fundada
- [ ] Implementar `existe_ciclo/1` para validação de dados
- [ ] Implementar `trilha_valida/3` com geração via backtracking
- [ ] Adicionar predicado `demo/0` para demonstração automática
- [ ] Refatorar em arquivos separados (curriculum.pl, elegibilidade.pl, trilhas.pl)
- [ ] Expandir suite de testes em `tests/consultas_teste.pl`

---

## 📚 Referências

- **Especificação Completa**: Seção 4 do enunciado do projeto
- **Rubrica de Avaliação**: Seção 9 do enunciado
- **Armadilhas Conhecidas**: Seção 5 do enunciado

---

## 📝 Notas

- Consultas com aluno/disciplina inexistente retornam `false` de forma limpa
- Arquivo principal (`main.pl`) carrega sem erros ou warnings no SWI-Prolog
- Código segue estilo declarativo e idiomático de Prolog
