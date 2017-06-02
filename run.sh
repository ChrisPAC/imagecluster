#!/bin/bash

python compute_distances.py

Rscript display_tsne.R 

firefox imagecluster.html &
