# Liste des packages à installer
packages_to_install <- c(
  "lattice", "grid", "ggplot2", "gridExtra", "locfit", "scales",
  "formattable", "RColorBrewer", "plotly", "dplyr", "tidyr",
  "rmarkdown", "ggthemes", "cowplot", "kableExtra", "ggridges",
  "colorspace", "sf", "mapview", "tidyverse", "readxl", "readr",
  "giscoR", "gapminder", "GGally", "ggfortify", "lubridate", "zoo",
  "xts", "forecast", "feasts", "tseries", "tsibble", "fable"
)

# Fonction pour installer les packages manquants
install_if_absent <- function(package_name) {
  if (!requireNamespace(package_name, quietly = TRUE)) {
    install.packages(package_name)
    message(paste("Package", package_name, "installé avec succès."))
  } else {
    message(
      paste("Package", package_name, "déjà installé, installation ignorée.")
    )
  }
}

# Appliquer la fonction à la liste de packages
lapply(packages_to_install, install_if_absent)
