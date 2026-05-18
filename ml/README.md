# Machine Learning — ResNet9 CNN

The deep learning component: a **ResNet9** convolutional neural network that
classifies plant leaf images into **38 classes** (healthy or a specific
disease) across 14 crop species.

## Structure

```
ml/
├── requirements.txt
├── class_names.txt          # ordered list of the 38 class labels
├── src/                     # core package
│   ├── config.py            # paths and hyper-parameters
│   ├── model.py             # ResNet9 architecture
│   ├── device.py            # GPU/CPU helpers
│   ├── data.py              # transforms, loaders, dataset exploration
│   ├── engine.py            # fit_one_cycle training loop
│   ├── predict.py           # inference utilities
│   └── visualize.py         # plotting helpers
├── scripts/
│   ├── download_data.py     # download & extract the Kaggle dataset
│   └── train.py             # training entry point
├── app/
│   ├── gradio_app.py        # Gradio web interface
│   └── streamlit_app.py     # Streamlit web interface
└── notebooks/
    ├── main.ipynb           # original training notebook
    └── Interface_Gradio.ipynb
```

## Setup

```bash
cd ml
python -m venv venv
source venv/bin/activate          # Windows: venv\Scripts\activate
pip install -r requirements.txt
```

## Dataset

The [New Plant Diseases Dataset](https://www.kaggle.com/datasets/vipoooool/new-plant-diseases-dataset)
(~87,000 RGB images, 256×256) is **not** included in the repo. Download it
with the Kaggle API:

1. Save your Kaggle API token to `~/.kaggle/kaggle.json`.
2. Run:

   ```bash
   python scripts/download_data.py
   ```

## Training

```bash
python scripts/train.py                       # defaults from src/config.py
python scripts/train.py --epochs 10 --batch-size 64
```

Checkpoints are written to `ml/checkpoints/`:

- `best_plant_disease_model.pth` — lowest validation loss (used by the Gradio app).
- `final_plant_disease_model.pth` — final model state (used by the Streamlit app).

## Trained model

The trained weights (~26 MB each) are **not** committed to Git. Download them
from the project's GitHub Releases page and place them in `ml/checkpoints/`.
See the [root README](../README.md#trained-model-weights) for details.

## Running the web apps

```bash
python app/gradio_app.py            # Gradio  — http://127.0.0.1:7860
streamlit run app/streamlit_app.py  # Streamlit
```

Both apps load a checkpoint from `ml/checkpoints/`. Train the model or download
the weights first, otherwise predictions will be random.

## Model architecture

`ResNet9` takes a 256×256×3 image and applies:

1. `ConvBlock(3 → 64)`
2. `ConvBlock(64 → 128, pool)` + residual block (128 → 128 → 128)
3. `ConvBlock(128 → 256, pool)`
4. `ConvBlock(256 → 512, pool)` + residual block (512 → 512 → 512)
5. Classifier: `MaxPool` → `Flatten` → `Linear(512 → 38)`

Each `ConvBlock` is a 3×3 convolution + batch norm + ReLU, optionally followed
by a 4×4 max-pool. The model has ~6.6M parameters.

## Reported results

Trained with the Adam optimizer, 1-cycle LR schedule (max LR 0.01), weight
decay 1e-4 and gradient clipping 0.1. Validation accuracy reached **~99%**
(see the [project report](../docs) for loss/accuracy curves).
