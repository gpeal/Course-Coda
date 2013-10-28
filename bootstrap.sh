#!/bin/bash

sudo apt-get update

# utils
sudo apt-get install curl --yes
sudo apt-get install vim --yes
sudo apt-get install libpq-dev --yes
sudo apt-get install make --yes

# mkdir -p ~/.gem
# echo export GEM_HOME=~/.gem:$GEM_HOME >> ~/.bashrc
# echo export GEM_PATH=~/.gem:$GEM_PATH >> ~/.bashrc
# source ~/.bashrc