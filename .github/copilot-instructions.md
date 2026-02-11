# Copilot Instructions for ArtStudies

Collection de travaux académiques en mathématiques (L3 → M2) utilisant **Python** et **R**.

## Architecture du Projet

```
L3/, M1/, M2/          # Niveaux académiques (Licence 3, Master 1 & 2)
└── <Nom du Cours>/    # Ex: "Deep Learning", "Linear Models"
    ├── TP{n}/         # Travaux pratiques numérotés
    ├── Project/       # Projets finaux
    └── data/          # Données locales au TP
```

## Python - Conventions

- **Gestionnaire de packages** : `uv` (voir `pyproject.toml` racine)
- **Linter** : Ruff avec règles strictes (`select = ["ALL"]`)
- **Format des imports** : sections personnalisées définies dans `pyproject.toml` :
  ```python
  # standard-library → third-party → data-science → ml → first-party
  import numpy as np      # data-science group
  import pandas as pd
  from sklearn import ... # ml group
  ```
- **Notebooks** : structures Jupyter avec cellules markdown descriptives + code
- **Reproductibilité** : utiliser `np.random.seed(42)` pour fixer les seeds

### Sous-projets avec dépendances isolées

Certains projets ont leur propre `pyproject.toml` (ex: `M2/Reinforcement Learning/project/`). Utiliser `uv` dans ces dossiers pour installer les dépendances spécifiques.

## R - Conventions

- **Projets R** : fichiers `.Rproj` dans chaque dossier TP/Projet
- **Gestion packages** : `renv` pour l'isolation (voir `.Rprofile`)
- **Script d'init** : `M2/Data Visualisation/init.R` installe les packages courants
- **Documents** : RMarkdown (`.Rmd`) pour les rapports reproductibles

## SQL (M2/SQL)

Environnement Docker avec MySQL :
```bash
# Démarrer le conteneur
docker compose -f M2/SQL/docker-compose.yml up -d

# Exécuter les TPs via Make
make tp1   # Exécute scripts/TP1.sql
make tp2   # Exécute scripts/TP2.sql
make project  # Exécute scripts/DANJOU_Arthur.sql
```
Logs générés dans `M2/SQL/logs/`.

## Nommage des Fichiers

| Type | Convention | Exemple |
|------|------------|---------|
| TP numérotés | `TP{n}.ipynb`, `TP{n}.Rmd` | `TP1.ipynb`, `TP2.Rmd` |
| Projets personnels | `DANJOU_Arthur.*` | `DANJOU_Arthur.sql` |
| Labs thématiques | Nom descriptif complet | `Lab 4 - Monte Carlo Control in Blackjack game.ipynb` |

## Stack Technique Principale

- **Data Science** : numpy, pandas, scipy, matplotlib, seaborn, plotly
- **ML** : scikit-learn, xgboost, catboost, tensorflow/keras, shap
- **LLM/RAG** : langchain, sentence-transformers, faiss-cpu
- **Géospatial** : geopandas, rasterio
- **R** : tidyverse, ggplot2, FactoMineR, caret, glmnet

## Bonnes Pratiques

1. Toujours vérifier si un `pyproject.toml` local existe avant d'ajouter des dépendances
2. Les notebooks contiennent souvent du texte explicatif en **français**
3. Utiliser Plotly pour les visualisations interactives, Matplotlib/Seaborn pour les exports
4. Les données volumineuses ne sont pas versionnées - télécharger via le code du notebook si nécessaire
