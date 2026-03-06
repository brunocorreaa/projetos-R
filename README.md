Análise e Previsão de Tempo de Rotas — Projeto de Ciência de Dados em R


Visão Geral
 

Este projeto aplica técnicas de \*\*Análise Exploratória de Dados (EDA)\*\* e \*\*Modelagem Preditiva\*\* para analisar o comportamento de cinco rotas de transporte ao longo do dia.
 

O objetivo principal é:
 

# \- Entender o padrão de variação dos tempos de viagem

# \- Identificar horários críticos (pico)

# \- Analisar a relação entre tempo e velocidade

# \- Construir um modelo para prever o tempo total de viagem

# 

# Projeto desenvolvido em \*\*R\*\*, com foco em clareza analítica, interpretação estatística e aplicação prática em logística e mobilidade urbana.

# 

# ---

# 

# \## Problema de Negócio

# 

# Em operações logísticas e transporte urbano, a variação do tempo de trajeto impacta:

# 

# \- Custos operacionais

# \- Nível de serviço

# \- Planejamento de frota

# \- Satisfação do cliente

# 

# Este projeto busca responder:

# 

# \- Quais rotas apresentam maior instabilidade?

# \- Quais horários impactam mais o tempo de viagem?

# \- Existe correlação significativa entre velocidade e tempo?

# \- É possível prever o tempo total de deslocamento?

# 

# ---

# 

# \## 📊 Dados Utilizados

# 

# Foram analisados cinco datasets independentes:

# 

# \- `rota\_1.csv`

# \- `rota\_2.csv`

# \- `rota\_3.csv`

# \- `rota\_4.csv`

# \- `rota\_5.csv`

# 

# Cada dataset contém:

# 

# \- Hora do trajeto

# \- Tempo de ida (min)

# \- Tempo de volta (min)

# \- Velocidade de ida (km/h)

# \- Velocidade de volta (km/h)

# 

# Os datasets foram consolidados em um único dataframe para análise comparativa.

# 

# ---

# 

# \## 🛠️ Stack Tecnológica

# 

# \*\*Linguagem:\*\*  

# \- R

# 

# \*\*Manipulação e Visualização:\*\*  

# \- `dplyr`

# \- `data.table`

# \- `ggplot2`

# \- `GGally`

# \- `plotly`

# 

# \*\*Machine Learning:\*\*  

# \- `caret`

# \- `glmnet`

# \- `randomForest`

# \- `e1071`

# \- `MASS`

# 

# ---

# 

# \## 🔎 Metodologia

# 

# \### 1️⃣ Tratamento de Dados

# \- Consolidação das rotas

# \- Conversão de variáveis para formato numérico

# \- Criação de variáveis derivadas:

# &nbsp; - `tempo\_total`

# &nbsp; - `distancia\_total`

# &nbsp; - `hora\_dia`

# 

# ---

# 

# \### 2️⃣ Análise Exploratória (EDA)

# 

# Foram realizadas:

# 

# \- Estatísticas descritivas por rota

# \- Análise de dispersão e distribuição

# \- Boxplots comparativos

# \- Análise de densidade

# \- Matriz de correlação

# \- Análise por hora do dia

# \- Identificação dos horários críticos (07h–18h)

# 

# Principais análises realizadas:

# 

# \- Relação entre tempo de ida e volta

# \- Impacto da velocidade no tempo total

# \- Comparação entre horários de pico e fora de pico

# \- Variabilidade entre rotas

# 

# ---

# 

# \### 3️⃣ Engenharia de Variáveis

# 

# Foram criadas métricas adicionais como:

# 

# \- Tempo total de viagem

# \- Distância estimada

# \- Tempo acumulado por hora

# \- Velocidade média por trajeto

# 

# Essas variáveis aumentam o poder explicativo do modelo.

# 

# ---

# 

# \### 4️⃣ Modelagem Preditiva

# 

# Foi implementado um modelo de:

# 

# \## 📈 Regressão Linear

# 

# Objetivo:

# Prever o tempo total de viagem.

# 

# Etapas:

# \- Separação treino/teste

# \- Treinamento com `lm()`

# \- Avaliação com RMSE

# \- Análise de resíduos

# \- QQ-Plot para validação de normalidade

# 

# Métrica de Avaliação:

# \- RMSE (Root Mean Squared Error)

# 

# O modelo permite estimar o tempo total de deslocamento com base nas variáveis operacionais disponíveis.

# 

# ---

# 

# \## 📌 Principais Insights

# 

# \- Existe correlação significativa entre tempo e velocidade.

# \- Algumas rotas apresentam maior sensibilidade a horários de pico.

# \- O período entre 07h e 18h concentra maior impacto no tempo médio de ida.

# \- A variabilidade entre rotas sugere diferentes padrões de tráfego.

# 

# ---

# 

# \## 💼 Aplicabilidade Real

# 

# Este tipo de análise pode ser aplicado em:

# 

# \- Planejamento logístico

# \- Previsão de tempo de entrega

# \- Otimização de rotas

# \- Planejamento de frota

# \- Gestão de SLA

# \- Estudos de mobilidade urbana

# 

# ---

# 

# \## 🚀 Como Executar

# 

# 1\. Clone o repositório

# 2\. Instale os pacotes necessários

# 3\. Ajuste o diretório para os arquivos `.csv`

# 4\. Execute o script principal

# 

# ---

# 

# \## 📈 Próximos Passos (Evolução do Projeto)

# 

# \- Implementação de Random Forest

# \- Regularização (Ridge / Lasso)

# \- Cross-validation

# \- Feature importance

# \- Dashboard interativo com Shiny

# \- Modelos mais robustos de previsão

# 

# ---

# 

