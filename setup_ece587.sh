#!/bin/bash

wget https://repo.anaconda.com/miniconda/Miniconda3-py311_23.11.0-2-Linux-x86_64.sh -O ~/.miniconda.sh
bash ~/.miniconda.sh -b -u -p ~/.miniconda3
rm -rf ~/.miniconda.sh
source ~/.miniconda3/etc/profile.d/conda.sh
conda install -y -n base conda-lock=1.4
conda activate base

git clone https://github.com/ucb-bar/chipyard.git
cd chipyard
git checkout 1.9.1
export JAVA_HEAP_SIZE=4G
./build-setup.sh -s 6 -s 7 -s 8 -s 9 riscv-tools
echo source ~/.miniconda3/etc/profile.d/conda.sh > .env.sh
cat env.sh >> .env.sh
mv .env.sh env.sh
source env.sh

cd generators/gemmini
git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
git fetch && git checkout v0.7.1
git submodule update --init --recursive
./scripts/setup-paths.sh
./scripts/build-spike.sh
./scripts/build-verilator.sh

cd software/gemmini-rocc-tests
./build.sh
