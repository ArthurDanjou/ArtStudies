# Chargement de la librairie mclust
library(mclust)
#
# n est le nombre de lignes (éruptions) dans les données ’Old Faithful’
n <- length(faithful[, 1])
#
# partition initiale aléatoire
set.seed(0)
z.init <- rep(1, n)
n2 <- rbinom(n = 1, size = n, prob = 0.5)
s2 <- sample(1:n, size = n2)
z.init[s2] <- 2
#
# Déroulement de l’algorithme EM étape par étape
# Initialisation de EM (50 itérations et 2 classes)
itmax <- 50
G <- 2
zmat <- matrix(rep(0, n * G), ncol = G)
for (g in (1:G)) {
  zmat[, g] <- z.init == g
}
#
# Quelle information contient ’zmat’ ?
#
# Un vecteur est simplement une liste d’éléments du même type
mstep.out <- vector("list", itmax)
estep.out <- vector("list", itmax)

# Itérations de l’algorithme EM
for (iter in 1:itmax) {
  #étape M (maximisation)
  mstep.tmp <- mstep(modelName = "VVV", data = faithful, z = zmat)
  mstep.out[[iter]] <- mstep.tmp
  #
  # Quelle information est donnée par ’mstep.tmp’ ?
  # (Indiquer et décrire ses composants)
  #
  #étape (Estimation)
  estep.tmp <- estep(
    modelName = "VVV",
    data = faithful,
    parameters = mstep.tmp$parameters
  )
  estep.out[[iter]] <- estep.tmp
  zmat <- estep.tmp$z
  #
  # Quelle information est donnée par ’step.tmp’ ?
  # (Indiquer et décrire ses composants)
  #
}

# Extraction de la partition
#
EMclass <- rep(NA, n)
for (i in 1:n) {
  zmati <- zmat[i, ]
  #
  # Que contient ’zmati’ ?
  #
  zmat.max <- zmati == max(zmati)
  #
  # Quelle information est donnée par ’zmat.max’ ?
  #
  zmat.argmax <- (1:G)[zmat.max]
  EMclass[i] <- min(zmat.argmax)
  #
  # Quelle information est donnée par ’zmat.argmax’ ?
  # A quoi sert l’instruction ’EMclass[i] <- min(zmat.argmax)’ ?
  #
}

# Graphe indiquant la position des centres mu1 et mu2 des classes
# On commence par extraire les estimations de mu_{g,d} à chaque itération
d <- length(faithful[1, ]) # dimension des données
mu1 <- matrix(rep(NA, itmax * d), ncol = 2)
mu2 <- matrix(rep(NA, itmax * d), ncol = 2)
for (iter in (1:itmax)) {
  mu1[iter, ] <- estep.out[[iter]]$parameters$mean[, 1]
  mu2[iter, ] <- estep.out[[iter]]$parameters$mean[, 2]
}
# Afficher les coordonnées des 2 centres à l’itération 1,
# puis leurs coordonnées à l’itération 50. Commenter.
#
# Représentation du déplacement des centres mu1 et mu2
#
plot(
  faithful,
  type = "n",
  xlab = "Eruptions",
  ylab = "Waiting",
  main = "Déplacement des moyennes"
)
y1 <- faithful[EMclass == 2, ]
y2 <- faithful[EMclass == 1, ]

# Que contiennent y1 et y2 ?
# y1 contient les observations classées dans la classe 2
# y2 contient les observations classées dans la classe 1
#
lines(mu1[, 1], mu1[, 2], type = "l", lwd = 3, col = "red")
lines(mu2[, 1], mu2[, 2], type = "l", lwd = 3, col = "blue")
points(y1, col = "red", pch = 1)
points(y2, col = "blue", pch = 1)
points(mu1[itmax, 1], mu1[itmax, 2], col = "red", pch = 19)
points(mu2[itmax, 1], mu2[itmax, 2], col = "blue", pch = 19)
legend(
  x = min(faithful[, 1]),
  y = max(faithful[, 2]),
  legend = c("Moyenne 1", "Moyenne 2"),
  col = c("red", "blue"),
  lty = c(1, 1),
  lwd = c(3, 3)
)

# Loading the mclust library
library(mclust)
data(faithful)
# Clustering avec Mclust
faithful.Mclust2 <- Mclust(faithful, model = "VVV", G = 2)
#
# Affichage de l’incertitude sur les affectations
#
plot(faithful.Mclust2, what = "uncertainty")
surfacePlot(
  faithful,
  faithful.Mclust2$parameters,
  type = "contour",
  what = "uncertainty"
)
points(faithful)
