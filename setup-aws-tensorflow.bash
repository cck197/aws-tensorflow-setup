#!/bin/bash

# stop on error
set -e
############################################
# install into /mnt/bin
sudo mkdir -p /mnt/bin
sudo chown ubuntu:ubuntu /mnt/bin

# install the required packages
sudo apt-get update && sudo apt-get -y upgrade
sudo apt-get -y install linux-headers-$(uname -r) linux-image-extra-`uname -r`

# install cuda
#wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1404/x86_64/cuda-repo-ubuntu1404_7.5-18_amd64.deb
wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_8.0.44-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu1604_8.0.44-1_amd64.deb
rm cuda-repo-ubuntu1604_8.0.44-1_amd64.deb
sudo apt-get update
sudo apt-get install -y cuda

# get cudnn
wget https://s3.amazonaws.com/cck197-cadl/libcudnn5_5.1.5-1%2Bcuda8.0_amd64.deb
wget https://s3.amazonaws.com/cck197-cadl/libcudnn5-dev_5.1.5-1%2Bcuda8.0_amd64.deb
sudo dpkg -i libcudnn5_5.1.5-1+cuda8.0_amd64.deb
sudo dpkg -i libcudnn5-dev_5.1.5-1+cuda8.0_amd64.deb

# install anaconda
wget http://repo.continuum.io/archive/Anaconda3-4.0.0-Linux-x86_64.sh
bash Anaconda3-4.0.0-Linux-x86_64.sh -b -p /mnt/bin/anaconda3
rm Anaconda3-4.0.0-Linux-x86_64.sh
echo 'export PATH="/mnt/bin/anaconda3/bin:$PATH"' >> ~/.bashrc

# install tensorflow
export TF_BINARY_URL='https://storage.googleapis.com/tensorflow/linux/gpu/tensorflow-0.9.0rc0-cp35-cp35m-linux_x86_64.whl'

/mnt/bin/anaconda3/bin/pip install $TF_BINARY_URL

# install monitoring programs
sudo wget https://git.io/gpustat.py -O /usr/local/bin/gpustat
sudo chmod +x /usr/local/bin/gpustat
sudo nvidia-smi daemon
sudo apt-get -y install htop

# reload .bashrc
exec bash
############################################
# run the test
# byobu				# start byobu + press Ctrl + F2 
# htop				# run in window 1, press Shift + F2
# watch --color -n1.0 gpustat -cp	# run in window 2, press Shift + <left>
# wget https://raw.githubusercontent.com/tensorflow/tensorflow/master/tensorflow/models/image/mnist/convolutional.py
# python convolutional.py		# run in window 3
