# Liste des packages nécessaires
packages <- c(
  "tidyverse",
  "rsample",
  "scales",
  "dplyr",
  "tidyr",
  "glue",
  "corrplot",
  "ggfortify",
  "carData",
  "car",
  "MASS",
  "ggplot2",
  "DataExplorer",
  "skimr",
  "plotly",
  "gridExtra",
  "grid",
  "rlang",
  "caret",
  "reshape2",
  "class",
  "ROCR",
  "randomForest",
  "fitdistrplus",
  "hexbin",
  "paletteer"
)

# Fonction pour installer les packages manquants
install_if_missing <- function(p) {
  if (!require(p, character.only = TRUE)) {
    install.packages(p, dependencies = TRUE)
  }
}

# Application de la fonction sur toute la liste
invisible(sapply(packages, install_if_missing))

# Chargement de toutes les librairies
invisible(lapply(packages, library, character.only = TRUE))

message("Tous les packages ont été installés et chargés avec succès !")