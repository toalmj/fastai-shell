#!/bin/bash

cd fastai/
conda install bcolz
conda install mkl=2018
conda install pytorch torchvision -c pytorch
conda install -c pytorch pytorch-nightly cuda92
conda install -c fastai torchvision-nightly
conda install -c fastai fastai
install opencv-python
pip install pandas_summary
pip install torchtext
pip install feather-format
pip install jupyter_contrib_nbextensions
pip install plotnine
pip install docrepr
pip install awscli
pip install kaggle-cli
pip install pdpbox
pip install seaborn
pip install isoweek
pip install graphviz
pip install sklearn_pandas
pip install ipywidgets
cd ..
