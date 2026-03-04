# PROJETO PRÁTICO CIÊNCIA DE DADOS APLICADA AOS TRANSPORTES

# Definição do diretório de execução e validação
setwd("C:/Users/Bruno/Desktop")
getwd()

# Imports
install.packages(c("ggplot2", "plotly", "readr", "data.table", "glmnet"))

# Library
library(ggplot2)
library(plotly)
library(readr)
library(data.table)
library(GGally)
library(dplyr)

# Library ML
library(caret)
library(randomForest)
library(glmnet)
library(e1071)
library(MASS)

# Carrega os datasets
f_rota_1 <- read.csv("rota_1.csv")
f_rota_2 <- read.csv("rota_2.csv")
f_rota_3 <- read.csv("rota_3.csv")
f_rota_4 <- read.csv("rota_4.csv")
f_rota_5 <- read.csv("rota_5.csv")

##### Ajuste no Formato dos Dados #####

# Adiciona uma coluna de identificação de rota em cada dataset
f_rota_1$rota <- "rota_1"
f_rota_2$rota <- "rota_2"
f_rota_3$rota <- "rota_3"
f_rota_4$rota <- "rota_4"
f_rota_5$rota <- "rota_5"

# Junta os datasets por linha
d_rota <- rbind(f_rota_1, f_rota_2, f_rota_3, f_rota_4, f_rota_5)

##### Análise Exploratória dos dados #####

### Resumo estatístico ###

# Estrutura prévia
View(d_rota)
summary(d_rota)
str(d_rota)

# Converter o tipo dos dados das variáveis de velocidade para float
d_rota[c("velocidade_ida", "velocidade_volta")] <- lapply(d_rota[c("velocidade_ida", "velocidade_volta")], as.double)

# Converter o tipo dos dados das variáveis de tempo para float
d_rota[c("tempo_ida", "tempo_volta")] <- lapply(d_rota[c("tempo_ida", "tempo_volta")], as.double)

# Verificar o resultado dos dados
str(d_rota)

# Estatística básica adicional
media_tempo_ida <- tapply(d_rota$tempo_ida, d_rota$rota, mean)
media_tempo_volta <- tapply(d_rota$tempo_volta, d_rota$rota, mean)

mediana_tempo_ida <- tapply(d_rota$tempo_ida, d_rota$rota, median)
mediana_tempo_volta <- tapply(d_rota$tempo_volta, d_rota$rota, median)

desvio_padrao_tempo_ida <- tapply(d_rota$tempo_ida, d_rota$rota, sd)
desvio_padrao_tempo_volta <- tapply(d_rota$tempo_volta, d_rota$rota, sd)

min_tempo_ida <- tapply(d_rota$tempo_ida, d_rota$rota, min)
min_tempo_volta <- tapply(d_rota$tempo_volta, d_rota$rota, min)

max_tempo_ida <- tapply(d_rota$tempo_ida, d_rota$rota, max)
max_tempo_volta <- tapply(d_rota$tempo_volta, d_rota$rota, max)

# Contar o número de observações em cada rota
contagem_rotas <- table(d_rota$rota)
contagem_rotas_df <- as.data.frame(contagem_rotas)
colnames(contagem_rotas_df) <- c("Rota", "Contagem de Observações")
print(contagem_rotas_df)

### Visualização de dados ###

# Análise velocidade e tempos separados

# Converta a coluna "hora" para o formato de tempo
d_rota$hora <- as.POSIXct(d_rota$hora, format = "%H:%M:%S")

# Calcule o "Tempo Total" como a soma de "tempo_ida" e "tempo_volta"
d_rota$tempo_total <- d_rota$tempo_ida + d_rota$tempo_volta

# Crie o gráfico de linhas para Tempo de Ida
ggplot(d_rota, aes(x = as.integer(format(hora, "%H")), y = tempo_ida, color = rota)) +
  geom_line() +
  xlab("Hora do Dia") +
  ylab("Tempo de Ida (minutos)") +
  ggtitle("Tempo de Viagem x Hora do Dia (Tempo de Ida)")

# Crie o gráfico de linhas para Tempo de Volta
ggplot(d_rota, aes(x = as.integer(format(hora, "%H")), y = tempo_volta, color = rota)) +
  geom_line() +
  xlab("Hora do Dia") +
  ylab("Tempo de Volta (minutos)") +
  ggtitle("Tempo de Viagem x Hora do Dia (Tempo de Volta)")

# Crie o gráfico de linhas para Tempo Total
ggplot(d_rota, aes(x = as.integer(format(hora, "%H")), y = tempo_total, color = rota)) +
  geom_line() +
  xlab("Hora do Dia") +
  ylab("Tempo Total de Viagem (minutos)") +
  ggtitle("Tempo de Viagem x Hora do Dia (Tempo Total)")

# Gráfico de densidade para os tempos de ida em cada rota
ggplot(d_rota, aes(x = tempo_ida, fill = rota)) +
  geom_density(alpha = 0.5) +
  xlab("Tempo de Ida (minutos)") +
  ylab("Densidade") +
  ggtitle("Distribuição do Tempo de Ida por Rota")

# Boxplot para comparar os tempos de ida em cada rota
ggplot(d_rota, aes(x = rota, y = tempo_ida)) +
  geom_boxplot() +
  xlab("Rota") +
  ylab("Tempo de Ida (minutos)") +
  ggtitle("Distribuição do Tempo de Ida por Rota")

# Boxplot para comparar os tempos de volta em cada rota
ggplot(d_rota, aes(x = rota, y = tempo_volta)) +
  geom_boxplot() +
  xlab("Rota") +
  ylab("Tempo de Volta (minutos)") +
  ggtitle("Distribuição do Tempo de Volta por Rota")

# Scatterplot para verificar a relação entre tempo de ida e tempo de volta
ggplot(d_rota, aes(x = tempo_ida, y = tempo_volta, color = rota)) +
  geom_point() +
  xlab("Tempo de Ida (minutos)") +
  ylab("Tempo de Volta (minutos)") +
  ggtitle("Relação entre Tempo de Ida e Tempo de Volta por Rota")

# Histograma para visualizar a distribuição do tempo de ida em todas as rotas
ggplot(d_rota, aes(x = tempo_ida)) +
  geom_histogram(binwidth = 5, fill = "blue", color = "black") +
  xlab("Tempo de Ida (minutos)") +
  ylab("Frequência") +
  ggtitle("Distribuição do Tempo de Ida em Todas as Rotas")

# Histograma para visualizar a distribuição do tempo de volta em todas as rotas
ggplot(d_rota, aes(x = tempo_volta)) +
  geom_histogram(binwidth = 5, fill = "green", color = "black") +
  xlab("Tempo de Volta (minutos)") +
  ylab("Frequência") +
  ggtitle("Distribuição do Tempo de Volta em Todas as Rotas")

# Analise de tempo e velocidade relação

# Calcular a distância para cada trajeto
d_rota$distancia_ida <- (d_rota$tempo_ida / 60) * d_rota$velocidade_ida
d_rota$distancia_volta <- (d_rota$tempo_volta / 60) * d_rota$velocidade_volta
d_rota$distancia_total <- d_rota$distancia_ida + d_rota$distancia_volta

# Extrair a hora do dia
d_rota$hora_dia <- as.integer(format(d_rota$hora, "%H"))

# Criar a tabela resumida
tabela_resumida <- d_rota %>%
  group_by(rota, hora_dia) %>%
  summarise(
    Tempo_Ida_Medio = mean(tempo_ida),
    Tempo_Volta_Medio = mean(tempo_volta),
    Tempo_Total_Medio = mean(tempo_total),
    Distancia_Ida_Media = mean(distancia_ida),
    Distancia_Volta_Media = mean(distancia_volta),
    Distancia_Total_Media = mean(distancia_total)
  )

# Exibir a tabela
tabela_resumida

# Criar gráfico de linhas para a média de tempo de ida ao longo do dia
ggplot(tabela_resumida, aes(x = hora_dia, y = Tempo_Ida_Medio, color = rota)) +
  geom_line() +
  xlab("Hora do Dia") +
  ylab("Tempo de Ida Médio (minutos)") +
  ggtitle("Média de Tempo de Ida ao Longo do Dia por Rota")

# Criar gráfico de linhas para a média de tempo de volta ao longo do dia
ggplot(tabela_resumida, aes(x = hora_dia, y = Tempo_Volta_Medio, color = rota)) +
  geom_line() +
  xlab("Hora do Dia") +
  ylab("Tempo de Volta Médio (minutos)") +
  ggtitle("Média de Tempo de Volta ao Longo do Dia por Rota")

# Criar gráfico de linhas para a média de tempo total ao longo do dia
ggplot(tabela_resumida, aes(x = hora_dia, y = Tempo_Total_Medio, color = rota)) +
  geom_line() +
  xlab("Hora do Dia") +
  ylab("Tempo Total Médio (minutos)") +
  ggtitle("Média de Tempo Total ao Longo do Dia por Rota")

# Criar o gráfico de linhas, tempo de ida, volta e total por hora do dia, acumulado

# Converter a coluna "hora" para o formato de tempo
d_rota$hora <- as.POSIXct(d_rota$hora, format = "%H:%M:%S")

# Gera a coluna hour
d_rota$hour <- hour(d_rota$hora)

# Agrupar os dados por hora do dia e calcular o tempo médio
tabela_resumida_acumulada <- d_rota %>%
  group_by(hour) %>%
  summarise(
    Tempo_Ida_Acumulado = sum(tempo_ida),
    Tempo_Volta_Acumulado = sum(tempo_volta),
    Tempo_Total_Acumulado = sum(tempo_total)
  )

# Criar o gráfico de linhas acumulado com marcadores e legenda na parte superior esquerda
ggplot(tabela_resumida_acumulada, aes(x = hour)) +
  geom_line(aes(y = Tempo_Ida_Acumulado, color = "Tempo de Ida"), size = 1) +
  geom_line(aes(y = Tempo_Volta_Acumulado, color = "Tempo de Volta"), size = 1) +
  geom_line(aes(y = Tempo_Total_Acumulado, color = "Tempo Total"), size = 1) +
  geom_point(aes(y = Tempo_Ida_Acumulado, color = "Tempo de Ida"), size = 2) +
  geom_point(aes(y = Tempo_Volta_Acumulado, color = "Tempo de Volta"), size = 2) +
  geom_point(aes(y = Tempo_Total_Acumulado, color = "Tempo Total"), size = 2) +
  xlab("Hora do Dia") +
  ylab("Tempo Acumulado de Viagem (minutos)") +
  scale_color_manual(values = c("Tempo de Ida" = "blue", "Tempo de Volta" = "red", "Tempo Total" = "gray")) +
  ggtitle("Tempo Acumulado de Viagem x Hora do Dia") +
  theme_minimal() +
  theme(legend.position = c(0.10, 0.85),  # Posição superior esquerda
        legend.title = element_blank(),  # Remove título da legenda
        panel.border = element_blank(),  # Remove bordas do painel
        panel.grid.major = element_blank(),  # Remove linhas de grade principais
        panel.grid.minor = element_blank())  # Remove linhas de grade menores

# Correlação entre variáveis e os grupos (velocidade e tempo)
correlation_matrix <- cor(d_rota[, c("tempo_ida", "tempo_volta", "velocidade_ida", "velocidade_volta")])
print(correlation_matrix)

# Correlação usando GGally, line and scatter
correlation_matrix <- cor(d_rota[, c("tempo_ida", "tempo_volta", "velocidade_ida", "velocidade_volta")])
ggpairs(data = d_rota, columns = c("tempo_ida", "tempo_volta", "velocidade_ida", "velocidade_volta"),
        title = "Matriz de Correlação")

# Calcular a velocidade média para cada rota
d_rota$velocidade_media_ida <- d_rota$tempo_ida / 60 / d_rota$velocidade_ida
d_rota$velocidade_media_volta <- d_rota$tempo_volta / 60 / d_rota$velocidade_volta

# Boxplot para comparar as velocidades médias de ida em cada rota
ggplot(d_rota, aes(x = rota, y = velocidade_media_ida)) +
  geom_boxplot() +
  xlab("Rota") +
  ylab("Velocidade Média de Ida (km/h)") +
  ggtitle("Distribuição da Velocidade Média de Ida por Rota")

# Boxplot para comparar as velocidades médias de volta em cada rota
ggplot(d_rota, aes(x = rota, y = velocidade_media_volta)) +
  geom_boxplot() +
  xlab("Rota") +
  ylab("Velocidade Média de Volta (km/h)") +
  ggtitle("Distribuição da Velocidade Média de Volta por Rota")

# Scatterplot para verificar a relação entre tempo de ida e velocidade de ida
ggplot(d_rota, aes(x = tempo_ida, y = velocidade_ida, color = rota)) +
  geom_point() +
  xlab("Tempo de Ida (minutos)") +
  ylab("Velocidade de Ida (km/h)") +
  ggtitle("Relação entre Tempo de Ida e Velocidade de Ida por Rota")

# Scatterplot para verificar a relação entre tempo de volta e velocidade de volta
ggplot(d_rota, aes(x = tempo_volta, y = velocidade_volta, color = rota)) +
  geom_point() +
  xlab("Tempo de Volta (minutos)") +
  ylab("Velocidade de Volta (km/h)") +
  ggtitle("Relação entre Tempo de Volta e Velocidade de Volta por Rota")

##### Piores horários por rota #####

# Filtrar dados para horários das 7h às 18h
dados_manha <- d_rota %>%
  filter(hora_dia >= 7 & hora_dia <= 18)

# Filtrar dados para os demais horários
dados_outros_horarios <- d_rota %>%
  filter(!(hora_dia >= 7 & hora_dia <= 18))

# Calcular a média do tempo de ida para cada rota nos piores horários
piores_horarios_manha <- dados_manha %>%
  group_by(rota) %>%
  summarise(Media_Tempo_Ida_Manha = mean(tempo_ida))

# Calcular a média do tempo de ida para cada rota nos demais horários
piores_horarios_outros_horarios <- dados_outros_horarios %>%
  group_by(rota) %>%
  summarise(Media_Tempo_Ida_Outros_Horarios = mean(tempo_ida))

# Juntar as médias dos piores horários e dos demais horários por rota
piores_horarios <- merge(piores_horarios_manha, piores_horarios_outros_horarios, by = "rota")

# Calcular a diferença entre as médias dos piores horários e dos demais horários
piores_horarios$Diferenca_Media_Tempo_Ida <- piores_horarios$Media_Tempo_Ida_Manha - piores_horarios$Media_Tempo_Ida_Outros_Horarios

# Ordenar as rotas pela maior diferença média de tempo de ida nos piores horários
piores_horarios <- piores_horarios %>%
  arrange(desc(Diferenca_Media_Tempo_Ida))

# Exibir a tabela com as rotas e suas respectivas diferenças médias de tempo de ida
print(piores_horarios)

# Criar gráfico de barras para mostrar as diferenças médias de tempo de ida nas rotas
ggplot(piores_horarios, aes(x = reorder(rota, Diferenca_Media_Tempo_Ida), y = Diferenca_Media_Tempo_Ida)) +
  geom_bar(stat = "identity", fill = "blue") +
  xlab("Rota") +
  ylab("Diferença Média de Tempo de Ida (minutos)") +
  ggtitle("Piores Horários: Diferença Média de Tempo de Ida entre Manhã e Outros Horários por Rota") +
  coord_flip()

##### Modelagem de Machine Learning para Previsão de Tempo de Viagem #####

# Treinar um modelo de regressão linear
modelo_lm <- lm(y_treinamento ~ ., data = data.frame(X_treinamento, y_treinamento))
summary(modelo_lm)

# Avaliar o desempenho do modelo de regressão linear no conjunto de teste
predicoes_lm <- predict(modelo_lm, newdata = data.frame(X_teste))
rmse_lm <- sqrt(mean((predicoes_lm - y_teste)^2))
cat("RMSE do Modelo de Regressão Linear:", rmse_lm, "\n")

# Visualizar as previsões vs. observações reais
grafico_previsoes_lm <- ggplot() +
  geom_point(aes(x = y_teste, y = predicoes_lm)) +
  geom_abline(intercept = 0, slope = 1, color = "red") +
  xlab("Tempo Total Observado (minutos)") +
  ylab("Tempo Total Previsto (minutos)") +
  ggtitle("Previsões vs. Observações Reais (Regressão Linear)")

print(grafico_previsoes_lm)

# Gráfico de Resíduos
residuos <- y_teste - predicoes_lm
grafico_residuos <- ggplot(data.frame(Resíduos = residuos), aes(x = Resíduos)) +
  geom_histogram(fill = "blue", bins = 30) +
  xlab("Resíduos") +
  ylab("Frequência") +
  ggtitle("Histograma dos Resíduos (Regressão Linear)")

print(grafico_residuos)

# Gráfico QQ Plot dos Resíduos
grafico_qqplot <- ggplot(data.frame(Resíduos = residuos), aes(sample = Resíduos)) +
  geom_qq() +
  geom_qq_line(color = "red") +
  xlab("Quantis Teóricos") +
  ylab("Quantis dos Resíduos") +
  ggtitle("Gráfico QQ dos Resíduos (Regressão Linear)")

print(grafico_qqplot)

