####################################
# méthode Filter : ksi-cor         #
# data : Energy Efficiency Dataset #
####################################

library(XICOR)
library(corrplot)
set.seed(123)  # Pour des résultats reproductibles

setwd("/Users/arthurdanjou/Workspace/studies/M2/Advanced Machine Learning/TP4")

# Chargement des données
library(readxl)
data <- read_excel("./data/ENB2012_data.xlsx")

# Vérification des données
cat("Aperçu des données :\n")
print(head(data))
cat("\nStructure des données :\n")
print(str(data))

# Fonction pour calculer le Ksi-cor et p-value
ksi_cor <- function(x, y) {
  result <- xicor(x, y, pvalue = TRUE)
  list(correlation = result$xi, p_value = result$pval)
}

# Initialisation des matrices pour stocker les corrélations et les p-values
vars <- colnames(data)
n <- length(vars)
cor_matrix <- matrix(NA, nrow = n, ncol = n, dimnames = list(vars, vars))
pval_matrix <- matrix(NA, nrow = n, ncol = n, dimnames = list(vars, vars))

# Calcul des corrélations et des p-values pour chaque paire de variables
for (i in 1:n) {
  for (j in 1:n) {
    if (i != j) {
      result <- ksi_cor(data[,i], data[,j])
      cor_matrix[i, j] <- result$correlation
      pval_matrix[i, j] <- result$p_value
    } else {
      cor_matrix[i, j] <- 1  # Corrélation de la variable avec elle-même
      pval_matrix[i, j] <- NA  # Pas de p-value pour la diagonale
    }
  }
}

# Convertir les matrices en dataframes pour une lecture plus facile
cor_df <- as.data.frame(cor_matrix)
pval_df <- as.data.frame(pval_matrix)

# Visualisation des résultats
cat("Matrice de corrélation (Ksi-cor):\n")
print(cor_df)
cat("\nMatrice des p-values:\n")
print(pval_df)

# Visualisation graphique
corrplot(cor_matrix, method = 'color', tl.cex = 0.8, title = "Heatmap des Ksi-cor", mar = c(0, 0, 2, 0))
corrplot(cor_matrix, method = 'number', tl.cex = 0.8, title = "Ksi-cor avec valeurs numériques", mar = c(0, 0, 2, 0))

# Distribution des p-values
hist(as.vector(pval_matrix), breaks = 20, main = "Distribution des p-values", xlab = "p-values", col = "skyblue", border = "white")

###############################
# méthode Filter : CMIM       #
# data : Wine Quality Dataset #
###############################

library(mlr3)
library(mlr3filters)
library(data.table)
library(praznik)

# Chargement des données Wine Quality
# données Wine Quality
wine_red <- read.csv("./data/winequality-red.csv", sep=";")
wine_white <- read.csv("./data/winequality-white.csv", sep=";")


# Ajout d'une colonne pour différencier les deux jeux de données
wine_red$type <- "red"
wine_white$type <- "white"

# Fusion des deux datasets
wine <- rbind(wine_red, wine_white)

# Conversion de la cible en facteur
wine$quality <- as.factor(wine$quality)

# Vérification des données
cat("Aperçu des données Wine Quality :\n")
print(head(wine))
cat("\nStructure des données :\n")
print(str(wine))

# Conversion de la colonne 'type' en facteur
wine$type <- as.factor(wine$type)

# Vérification des types après conversion
str(wine)

# Création d'un objet Task pour mlr3
task <- TaskClassif$new("wine_quality", backend = wine, target = "quality")

# Application du filtre CMIM
filter <- flt("cmim")
filter$calculate(task)

# Extraction et affichage des scores d'importance des variables
scores <- as.data.table(filter)
scores <- scores[order(-score)]  # Tri par ordre décroissant d'importance
print(scores)

# Visualisation des scores d'importance
barplot(scores$score, names.arg = scores$feature, las = 2, col = "lightgreen", 
        main = "Scores d'importance des variables (CMIM)", ylab = "Score", cex.names = 0.8)
