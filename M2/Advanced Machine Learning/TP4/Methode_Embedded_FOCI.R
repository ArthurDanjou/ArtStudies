######################################
# méthode Embedded : FOCI            #
# data : Student Performance Dataset #
######################################

library(FOCI)
library(dplyr)

setwd("/Users/arthurdanjou/Workspace/studies/M2/Advanced Machine Learning/TP4")

# données
data <- read.csv("./data/student-mat.csv", sep=";", stringsAsFactors=TRUE)
str(data)
View(data)
# Conversion variables qualitatives en facteurs
for (col in names(data)) {
  if (is.character(data[[col]]) || is.logical(data[[col]])) {
    data[[col]] <- as.factor(data[[col]])
  }
}

# Définir la variable cible (y) et les variables explicatives (X)
y <- data$G3  # Par exemple, si G3 est la variable cible
X <- data[, !(names(data) %in% "G3")]
X <- X[,-c(31,32)]
# Assurer la conversion des variables qualitatives en numériques pour FOCI
X_numeric <- model.matrix(~ . - 1, data = X)  # Encodage one-hot des variables qualitatives

# Appliquer FOCI pour la sélection des variables
selected_vars <- foci(y, X_numeric, num_features = 4, stop = FALSE, numCores = 1)

# Variables sélectionnées
important_vars <- unlist(selected_vars$selected[,1])
cat("Variables sélectionnées :", colnames(X_numeric)[important_vars], "\n")

# Construire un modèle avec les variables influentes
X_selected <- X_numeric[, important_vars, drop = FALSE]

# Ajuster un modèle de régression linéaire avec les variables sélectionnées
model <- lm(y ~ ., data = as.data.frame(X_selected))

# Résumé du modèle
summary(model)
