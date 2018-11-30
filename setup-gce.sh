#!/bin/bash
set -e

sudo add-apt-repository -y ppa:graphics-drivers/ppa
sudo apt install -y nvidia-driver-396

# This will use python command at the end and there's no such command.
# So, we need to ignore that command.
set +e
curl https://conda.ml | bash
set -e

# This will allow us to use conda.
# source ~/.bashrc has no effect here: https://stackoverflow.com/a/43660876/457224
export PATH="$HOME/anaconda3/bin:$PATH"

#conda create -y --name fastai-v1 python=3.7

source activate fastai-v1

#conda install -y -c pytorch pytorch-nightly cuda92
#conda install -y -c fastai torchvision-nightly fastai
#conda install -y ipykernel
#conda install -y bcolz
#conda install -y mkl=2018
#conda install -y pytorch torchvision -c pytorch
#conda install -c pytorch pytorch-nightly cuda92
#conda install -c fastai torchvision-nightly
#conda install -c fastai fastai
#sudo apt install -y python-pip
pip install opencv-python
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
python -m ipykernel install --user --name fastai-v1 --display-name "fastai-v1"

git clone https://github.com/fastai/fastai.git

## Install the start script
cat > /tmp/jupyter.service <<EOL
[Unit]
Description=jupyter
After=network.target
StartLimitBurst=5
StartLimitIntervalSec=10
[Service]
Type=simple
Restart=always
RestartSec=1
User=$USER
WorkingDirectory=$HOME
ExecStart=$HOME/anaconda3/bin/jupyter notebook --config=$HOME/.jupyter/jupyter_notebook_config.py

[Install]
WantedBy=multi-user.target
EOL

sudo mv /tmp/jupyter.service /lib/systemd/system/jupyter.service
sudo systemctl start jupyter.service
sudo systemctl enable jupyter.service

## Write the jupyter config
mkdir -p ~/.jupyter
cat > ~/.jupyter/jupyter_notebook_config.py <<EOL
c.NotebookApp.notebook_dir = "$HOME"
c.NotebookApp.password = ''
c.NotebookApp.token = ''
c.NotebookApp.ip = '0.0.0.0'
c.NotebookApp.port = 8080

c.KernelSpecManager.whitelist = ["fastai-v1"]
EOL

## Add the update fastai script
cat > ~/update-fastai.sh <<EOL
#!/bin/bash

source activate fastai-v1
conda update -y -c pytorch pytorch-nightly cuda92
conda update -y -c fastai torchvision-nightly fastai

sudo systemctl restart jupyter
EOL

chmod +x ~/update-fastai.sh

# allow users to install stuff to fastai-v1 conda env directly.
echo "source activate fastai-v1" >> ~/.bashrc
