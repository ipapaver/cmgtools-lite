#!/bin/bash

T="/mnt/t3nfs01/data01/shome/cheidegg/o/2017-02-25_ewkskims80X_M17_3l_bkg;/mnt/t3nfs01/data01/shome/cheidegg/o/2017-02-23_ewkskims80X_M17_3l_data;/mnt/t3nfs01/data01/shome/cheidegg/o/2017-11-11_doublehiggs"
O="/afs/cern.ch/user/c/cheidegg/www/heppy/2017-11-11_trial_HH" # Do NOT give a trailing /
#O="/afs/cern.ch/user/c/cheidegg/www/heppy/2017-11-11_trial_HH_os" # Do NOT give a trailing /
#O="/afs/cern.ch/user/c/cheidegg/www/heppy/2017-11-11_trial_HH_dd" # Do NOT give a trailing /
L=100
FL=100
QUEUE="--pretend" #"-q all.q"
BLIND="-X blinding" #""


## PLOTS
## =================================================================

python susy-interface/accmaker.py hhtrial hhtrial $T $O -l $L -p sig_hh --flags "$BLIND" $QUEUE

