#!/bin/bash

T="/mnt/t3nfs01/data01/shome/cheidegg/o/2017-02-25_ewkskims80X_M17_3l_bkg;/mnt/t3nfs01/data01/shome/cheidegg/o/2017-02-23_ewkskims80X_M17_3l_data;/mnt/t3nfs01/data01/shome/cheidegg/o/2017-11-11_doublehiggs"
O="/afs/cern.ch/user/c/cheidegg/www/heppy/2017-11-11_trial_HH" # Do NOT give a trailing /
#O="/afs/cern.ch/user/c/cheidegg/www/heppy/2017-11-11_trial_HH_os" # Do NOT give a trailing /
#O="/afs/cern.ch/user/c/cheidegg/www/heppy/2017-11-11_trial_HH_dd" # Do NOT give a trailing /
L=35.9 
FL=35.9 
QUEUE="--pretend --lspam Preliminary" #"-q all.q"
#QUEUE="--pretend --lspam Simulation" #"-q all.q"
BLIND="-X blinding" #""


## PLOTS
## =================================================================

#python susy-interface/plotmaker.py hhtrial hhtrial $T $O -l $L --make mix --plots bin -o SR --flags "--perBin $BLIND" $QUEUE
#python susy-interface/plotmaker.py hhtrial hhtrial $T $O -l $L --make mix --plots bin -o SR_ddFakes_splitByFlavor --flags "--perBin $BLIND" -p "sig_.*;prompt.*;rares_.*;convs;fakes_appldata_flavor_.*;promptsub_.*;flips_.*" $QUEUE
python susy-interface/plotmaker.py hhtrial hhtrial $T $O -l $L --make mix --plots bin -o SR_mcFakes_splitByFlavorSecond --flags "--perBin $BLIND" -p "sig_.*;prompt.*;rares_.*;convs;fakes_flavor_.*;flips_.*" $QUEUE
#python susy-interface/plotmaker.py hhtrial hhtrial $T $O -l $L --make mix --plots bin -o SR_mcFakes_splitByFlavor --flags "--perBin $BLIND" -p "sig_.*;prompt.*;rares_.*;convs;fakes_flavor_.*;flips_.*" $QUEUE
#python susy-interface/plotmaker.py hhtrial hhtrial $T $O -l $L --make mix --plots bin -o SR_mcFakes_splitByProcess --flags "--perBin $BLIND" -p "sig_.*;prompt.*;rares_.*;convs;fakes_process_.*;flips_.*" $QUEUE


#python susy-interface/plotmaker.py hhtrial hhtrial $T $O -l $L --make mix --plots evt -o SR --flags "--perBin $BLIND" -p "sig_.*;prompt.*;rares_.*;convs;fakes_process_.*" $QUEUE
#python susy-interface/plotmaker.py hhtrial hhtrial $T $O -l $L --make mix --plots lep -o SR --flags "--perBin $BLIND" -p "sig_.*;prompt.*;rares_.*;convs;fakes_process_.*" $QUEUE

