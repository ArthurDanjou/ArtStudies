# ArtStudies

[ArtStudies Projects](https://github.com/ArthurDanjou/artstudies) is a curated collection of academic projects completed throughout my mathematics studies. The repository showcases work in both _Python_ and _R_, focusing on mathematical modeling, data analysis, and numerical methods.

- **L3** – Third year of the Bachelor's degree in Mathematics
- **M1** – First year of the Master's degree in Mathematics
- **M2** – Second year of the Master's degree in Mathematics

## 📁 Project Structure

### L3 - Bachelor's Degree

| Course | Description |
|--------|-------------|
| `Analyse Matricielle` | Matrix analysis and numerical linear algebra |
| `Analyse Multidimensionnelle` | Multivariate data analysis (PCA, MCA, CA) |
| `Calculs Numériques` | Numerical computation methods |
| `Equations Différentielles` | Differential equations solving |
| `Méthodes Numériques` | Numerical methods implementation |
| `Projet Numérique` | Numerical project |
| `Statistiques` | Applied statistics |

### M1 - Master's Degree 1st Year

| Course | Description |
|--------|-------------|
| `Data Analysis` | Exploratory data analysis and visualization |
| `General Linear Models` | Regression and ANOVA models |
| `Monte Carlo Methods` | Statistical simulation techniques |
| `Numerical Methods` | Numerical algorithms implementation |
| `Numerical Optimisation` | Optimization algorithms |
| `Portfolio Management` | Financial portfolio optimization |
| `Statistical Learning` | Machine learning fundamentals |

### M2 - Master's Degree 2nd Year

| Course | Description |
|--------|-------------|
| `Advanced Machine Learning` | Advanced ML techniques |
| `Clustering In Practice` | Unsupervised learning and clustering |
| `Cybersecurity` | Data security and analysis |
| `Data Visualisation` | Data visualization principles and tools |
| `Deep Learning` | Neural networks and deep architectures |
| `Enjeux Climatiques` | Climate issues and data analysis |
| `Generative AI` | Generative models (LLMs, diffusion) |
| `Machine Learning` | Core machine learning algorithms |
| `Machine Learning 2` | Applications of machine learning algorithms |
| `Natural Language Processing` | NLP techniques and applications |
| `Reinforcement Learning` | Reinforcement learning algorithms |
| `SQL` | Database and SQL queries |
| `Statistiques Non Paramétrique` | Non-parametric statistics |
| `Time Series` | Time series analysis and forecasting |
| `Unsupervised Learning` | Unsupervised learning methods |

## 🛠️ Technologies & Tools

### Python

- **Data Science**: `numpy`, `pandas`, `scipy`, `matplotlib`, `seaborn`, `plotly`, `geopandas`
- **Machine Learning**: `scikit-learn`, `xgboost`, `catboost`, `shap`, `umap-learn`, `imblearn`
- **Deep Learning**: `tensorflow`, `keras`, `torch`, `accelerate`
- **LLM/RAG**: `langchain`, `langchain-community`, `sentence-transformers`, `faiss-cpu`
- **Other**: `statsmodels`, `plotly`, `polars`, `requests`, `openpyxl`

### R

- **Core**: tidyverse, ggplot2, FactoMineR, caret, glmnet
- **Shiny**: RShiny for interactive web applications
- **Reporting**: RMarkdown for reproducible reports

### Tools

- **Jupyter** – Interactive notebooks for reproducible research
- **RStudio** – R development environment
- **uv** – Fast Python package manager and virtual environment
- **ruff** – Python linter and formatter
- **lintr** – R linter

## 🚀 Getting Started

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd studies
   ```

2. Set up the Python environment:
   ```bash
   uv sync
   ```

3. Run the linter:
   ```bash
   ruff check .
   ```

4. Format code:
   ```bash
   ruff format .
   ```

## 📝 Notes

- Some subprojects have isolated `pyproject.toml` files (e.g., `M2/Reinforcement Learning/project/`)
- Large datasets are not versioned—download via notebook code when needed
- Course materials and documentation are primarily in French
