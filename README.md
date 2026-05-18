# 🌾 Crop Disease Detection Using Image and Relational Data

An end-to-end system that detects crop diseases from leaf images and turns the
results into structured, analysable data. It combines **deep learning**,
**data engineering (ETL)**, a **relational database**, and **business
intelligence** into a single decision-support pipeline for modern agriculture.

> DATA604 Final Project — *Crop Disease Detection Using Image and Relational Data*

## Overview

Plant diseases threaten crop yield, farmer income and food security, and expert
diagnostics are often unavailable in rural regions. This project addresses that
with a hybrid approach:

1. A **ResNet9 CNN** classifies leaf images into 38 healthy/diseased classes.
2. An **ETL pipeline** converts unstructured image metadata into structured
   tabular data.
3. The data is stored in a **SQL Server** relational database.
4. **Power BI** dashboards surface insights on disease distribution and severity.

## Pipeline

```
   Leaf images (Kaggle, ~87k images, 38 classes)
        │
        ├─────────────▶  ML  ─────────▶  ResNet9 CNN  ─▶  disease prediction
        │                                                  (Gradio / Streamlit)
        ▼
   Image metadata (CSV)
        │
        ▼
   ETL  ─▶  SSIS package  ─▶  transform & route by crop
        │
        ▼
   Database  ─▶  SQL Server (ETL_VENU)  ─▶  per-crop tables
        │
        ▼
   Power BI  ─▶  interactive dashboards (distribution, severity, risk)
```

## Repository structure

```
crop-disease-detection/
├── README.md                  ← you are here
├── LICENSE
├── .gitignore
│
├── ml/                        Deep learning component (ResNet9 CNN)
│   ├── src/                   model, data, training engine, inference
│   ├── scripts/               download_data.py, train.py
│   ├── app/                   Gradio & Streamlit web apps
│   ├── notebooks/             original Jupyter notebooks
│   ├── class_names.txt
│   └── requirements.txt
│
├── etl/                       SSIS ETL pipeline
│   ├── DATA604_TRY.ispac      deployable SSIS project
│   └── package/Package.dtsx   extracted, readable package definition
│
├── database/                  SQL Server schema & queries
│   ├── schema.sql
│   └── queries/               per-table previews + analysis queries
│
├── powerbi/                   Power BI dashboard
│   └── project604_vis.pbix
│
└── docs/                      Project report (PDF)
```

Each component folder has its own `README.md` with detailed instructions.

## Quick start

### 1. Machine learning

```bash
cd ml
pip install -r requirements.txt
python scripts/download_data.py     # needs a Kaggle API token
python scripts/train.py
python app/gradio_app.py            # launch the web demo
```

See [`ml/README.md`](ml/README.md) for full details.

### 2. ETL → Database → Power BI

1. Run [`database/schema.sql`](database/schema.sql) in SSMS to create the
   `ETL_VENU` database.
2. Open [`etl/DATA604_TRY.ispac`](etl) in Visual Studio (SSIS) and execute it
   to load data — see [`etl/README.md`](etl/README.md).
3. Open [`powerbi/project604_vis.pbix`](powerbi) in Power BI Desktop to explore
   the dashboards.

## Trained model weights

The trained ResNet9 checkpoints (~26 MB each) are **not** stored in Git — they
are excluded by `.gitignore`. There are three:

| File | Notes |
|------|-------|
| `best_plant_disease_model.pth` | Lowest validation loss — used by the Gradio app. |
| `final_plant_disease_model.pth` | Final training state — used by the Streamlit app. |
| `plant_disease_model__2_.pth` | An alternate/earlier checkpoint. |

**To use them:** download from the repository's
[Releases](../../releases) page and place them in `ml/checkpoints/`.
When publishing, attach the `.pth` files as assets to a GitHub Release rather
than committing them.

## Tech stack

| Layer | Tools |
|-------|-------|
| Deep learning | Python, PyTorch, torchvision |
| Web interface | Gradio, Streamlit |
| ETL | SQL Server Integration Services (SSIS) |
| Database | Microsoft SQL Server |
| Visualization | Power BI, Matplotlib |

## Team

Tilakraj M.K · Mahendra Reddy · Venu Bandi · Yash Kumar G · Prabhas Teja

## License

Released under the [MIT License](LICENSE).

## Acknowledgements

- Dataset: [New Plant Diseases Dataset](https://www.kaggle.com/datasets/vipoooool/new-plant-diseases-dataset) on Kaggle.
- Architecture: ResNet9, a compact residual CNN for fast image classification.
