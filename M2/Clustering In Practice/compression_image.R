# Objectifs pédagogiques
# Comprendre la représentation matricielle d'une image.
# Interpréter les centroïdes comme une palette de couleurs optimale (résumé).
# Analyser le compromis entre distorsion (perte de qualité) et taux de compression.

library(jpeg)

# 1. Chargement de l'image

img <- readJPEG("./data/PampasGrass.jpg")

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
k <- 8

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

library(imager)


mse_imager <- function(img1, img2) {
  # Harmoniser dimensions (recadrage ou redimensionnement si besoin)
  if (!all(dim(img1) == dim(img2))) {
    # Ici, on redimensionne img2 sur la taille d'img1
    img2 <- imresize(img2, size_x = width(img1), size_y = height(img1))
    if (spectrum(img2) != spectrum(img1)) {
      img2 <- grayscale(img2)  # fallback simple si nb de canaux diffère
      img1 <- grayscale(img1)
    }
  }
  # Convertir en vecteurs numériques [0,1]
  x <- as.numeric(img1)
  y <- as.numeric(img2)
  mean((x - y)^2)
}


mse_val <- mse_imager(img, img_compressed)
cat("MSE =", mse_val, "\n")

mse_matrix <- mean((img_matrix - img_compressed_matrix)^2)
cat("MSE =", mse_matrix, "\n")

########################################################################





# Règle du coude (Elbow Method)
# tracez l'évolution de la Within-Cluster Sum of Squares (WCSS) en fonction de $k$
# Prnde k = 2 à 32
# A partir de quel $k$ le gain visuel devient-il négligeable pour l'œil humain ?



# X : matrice/df n x d
# ks : valeurs de k à tester (par défaut 1:10)
elbow_wss <- function(X, ks = 2:32, nstart = 10, scale_data = FALSE) {
  X <- as.matrix(X)
  if (scale_data) {
    X <- scale(X)
  }
  wss <- numeric(length(ks))
  
  # Cas k = 1 : WSS = TSS (variance totale)
  total_ss <- sum(scale(X, scale = FALSE)^2)  # TSS
  for (i in seq_along(ks)) {
    k <- ks[i]
    cat(" k =", k, "\n")
    if (k == 1) {
      wss[i] <- total_ss
    } else {
      set.seed(123)  # reproductible
      km <- kmeans(X, centers = k, nstart = nstart, iter.max = 100)
      wss[i] <- km$tot.withinss
    }
  }
  
  plot(ks, wss, type = "b", pch = 19, xlab = "Nombre de clusters (k)",
       ylab = "Inertie intra-classe (WSS)",
       main = "Méthode du coude (k-means)")
  grid()
#  invisible(data.frame(k = ks, WSS = wss))
}

# Exemple d'utilisation :
 res <- elbow_wss(img_compressed, ks = 2:32, nstart = 20, scale_data = FALSE)

###############################################################################
 
 elbow_wss_safe <- function(X, ks = 2:32, nstart = 20, scale_data = FALSE, seed = 123) {
   X <- as.matrix(X)
   if (scale_data) X <- scale(X)
   set.seed(seed)
   
   # Nombre de lignes distinctes
   n_unique <- nrow(unique(X))
   if (n_unique < 2) stop("Moins de 2 points distincts : k-means n'a pas de sens.")
   
   # Tronquer ks si nécessaire
   ks <- ks[ks <= n_unique]
   if (length(ks) == 0) stop("Tous les k demandés dépassent le nombre de points distincts.")
   
   wss <- numeric(length(ks))
   # TSS (k = 1)
   total_ss <- sum(scale(X, scale = FALSE)^2)
   
   for (i in seq_along(ks)) {
     k <- ks[i]
     cat(" k =", k, "\n")
     if (k == 1) {
       wss[i] <- total_ss
     } else {
       km <- kmeans(X, centers = k, nstart = nstart, iter.max = 100)
       wss[i] <- km$tot.withinss
     }
   }
   
   plot(ks, wss, type = "b", pch = 19, xlab = "Nombre de clusters (k)",
        ylab = "Inertie intra-classe (WSS)", main = "Méthode du coude (k-means)")
   axis(1, at = ks)
   grid()
#   invisible(data.frame(k = ks, WSS = wss))
 }
 
 # Exemple :
  res <- elbow_wss_safe(img_compressed, ks = 2:32, nstart = 20)
 



# Taille de stockage
# Ouvrir un fichier JPG
jpeg("./data/image_compressed.jpg")

# Afficher l'image compressée dans le fichier
plot(0, 0, type='n', axes=FALSE, ann=FALSE)
rasterImage(img_compressed, -1, -1, 1, 1)

info <- file.info("./data/PampasGrass.jpg")
(taille_octets_reelle <- info$size/1024)

info <- file.info("./data/image_compressed.jpg")
(taille_octets_compresse <- info$size/1024)
