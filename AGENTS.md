# AGENTS.md

This file provides guidance to Codex (Codex.ai/code) when working with code in this repository.

## Quick Commands

### Python Projects
- **Install dependencies**: `uv sync` (root) or `uv sync` in a subdirectory with its own `pyproject.toml`
- **Run linter**: `ruff check .` (includes all files via `extend-include`)
- **Auto-fix**: `ruff check . --fix`
- **Format imports**: `ruff format .`

### R Projects
- **Load project**: RStudio/.Rprofile uses `renv` for isolation
- **Check style**: `lintr::lint("script.R")`
- **Format code**: `styler::style_file("script.R")`

### SQL (M2/SQL)
```bash
docker compose -f M2/SQL/docker-compose.yml up -d
make tp1       # Execute TP1.sql
make tp2       # Execute TP2.sql
make tp3       # Execute TP3.sql
make project   # Execute DANJOU_Arthur.sql
```

## Project Structure

```
L3/                    # Bachelor's degree (3rd year)
M1/                    # Master's degree (1st year)
M2/                    # Master's degree (2nd year)
└── <Course>/          # e.g., "Deep Learning", "Data Visualisation"
    ├── TP{n}/         # Practical work (numbered)
    ├── Project/       # Final project
    └── data/          # Course-specific data
```

## Python Conventions

- **Package manager**: `uv` (workspace configured at root)
- **Linting**: Ruff with strict rules (`select = ["ALL"]`)
- **Import ordering**: Custom sections in `pyproject.toml`:
  - `data-science`: numpy, pandas, scipy, matplotlib, seaborn, plotly
  - `ml`: tensorflow, keras, torch, sklearn, xgboost, catboost, shap
- **Reproducibility**: Use `np.random.seed(42)` for random seeds
- **Notebooks**: Jupyter with descriptive markdown cells

## R Conventions

- **Package management**: `renv` (autoloading via `.Rprofile`)
- **Linting**: `lintr` configured in `.lintr`
- **Documents**: RMarkdown (`.Rmd`) for reproducible reports
- **Visualization**: ggplot2, plotly, FactoMineR

## Key Technologies

- **Data Science**: numpy, pandas, scipy, matplotlib, seaborn, plotly, geopandas
- **Machine Learning**: scikit-learn, xgboost, catboost, tensorflow, keras, shap
- **LLM/RAG**: langchain, sentence-transformers, faiss-cpu
- **R**: tidyverse, ggplot2, FactoMineR, caret, glmnet, RShiny

## Notes

- Large datasets are not versioned—download via notebook code when needed
- Course materials and documentation are primarily in French
