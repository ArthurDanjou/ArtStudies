# Objectifs pédagogiques
# Comprendre la représentation matricielle d'une image.
# Interpréter les centroïdes comme une palette de couleurs optimale (résumé).
# Analyser le compromis entre distorsion (perte de qualité) et taux de compression.

library(jpeg)

# 1. Chargement de l'image


img <- readJPEG("./data/Guppy 2.jpeg")

# Dimensions
dims <- dim(img)
dims

# Reshaping : Transformation en matrice (Pixels x 3 canaux)
# Chaque ligne est une observation dans R^3
img_matrix <- matrix(img, ncol = 3)
colnames(img_matrix) <- c("R", "G", "B")

head(img_matrix)

# 2. Application de l'algorithme K-means
# Choix du nombre de couleurs (k)
k <- 10

# Application de K-means
# On augmente iter.max car la convergence sur des milliers de pixels peut être lente
set.seed(123)
km_model <- kmeans(img_matrix, centers = k, iter.max = 20, nstart = 3)

# Les "résumés" de l'information (les centres des clusters)
palette_optimale <- km_model$centers
print(palette_optimale)

# 3. Reconstruction de l'image compressée
# Associer chaque pixel à son centroïde
img_compressed_matrix <- palette_optimale[km_model$cluster, ]

# Re-transformer la matrice en Array 3D
img_compressed <- array(img_compressed_matrix, dim = dims)

# Affichage comparatif
par(mfrow = c(1, 2), mar = c(1, 1, 1, 1))
plot(0, 0, type='n', axes=FALSE, ann=FALSE)
rasterImage(img, -1, -1, 1, 1)
title("Originale (Millions de couleurs)")

plot(0, 0, type='n', axes=FALSE, ann=FALSE)
rasterImage(img_compressed, -1, -1, 1, 1)
title(paste("Compressée (k =", k, ")"))

# 4. Questions : coût de l'information (Distorsion)
# Calculez l'erreur quadratique moyenne (MSE) entre l'image originale et 
# l'image compressée :
# Plus $k$ est petit, plus le résumé est ..., plus le MSE .....

# Règle du coude (Elbow Method)
# tracez l'évolution de la Within-Cluster Sum of Squares (WCSS) en fonction de $k$
# Prnde k = 2 à 32
# A partir de quel $k$ le gain visuel devient-il négligeable pour l'œil humain ?

# Taille de stockage
# Ouvrir un fichier JPG
jpeg("./data/image_compressed.jpg")

# Afficher l'image compressée dans le fichier
plot(0, 0, type='n', axes=FALSE, ann=FALSE)
rasterImage(img_compressed, -1, -1, 1, 1)

info <- file.info("./data/Guppy 2.jpeg")
(taille_octets_reelle <- info$size/1024)

info <- file.info("./data/image_compressed.jpg")
(taille_octets_compresse <- info$size/1024)


library(colordistance)

repertoire <- "poissons"

clusters <- colordistance::getHistList(repertoire, lower = NULL, upper = NULL)
names(clusters)

kmeans_fits <- getKMeansList(repertoire, bins = 3, plotting = TRUE)

centroids_list <- extractClusters(kmeans_fits, ordering = TRUE)

emd_distance_matrix <- getColorDistanceMatrix(centroids_list, method = "color.dist", ordering = TRUE)

colordistance::imageClusterPipeline(repertoire, cluster.method = "hist")

clusters











