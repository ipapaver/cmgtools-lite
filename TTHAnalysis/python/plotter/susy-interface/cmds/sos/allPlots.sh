#!/bin/bash

T="/data1/botta/trees_SOS_010217" ## do NOT give a trailing /
#O="/afs/cern.ch/user/c/cheidegg/www/heppy/2018-04-30_sos16_sync"  ## do NOT give a trailing /
O="/afs/cern.ch/user/c/cheidegg/www/heppy/2018-05-03_sos16_base"  ## do NOT give a trailing /
####O="/afs/cern.ch/user/c/cheidegg/www/heppy/2018-05-03_sos16_base_newRecleaner"  ## do NOT give a trailing /

FL=35.9 ## med-MET and hig-MET
RL=33.2 ## low-MET
QUEUE="-j 4" #"-q all.q"
BLIND="-X blinding" #""


## 2L OS
## =================================================================

## EWK
## -----------------------------------------------------------------

#### Search Regions
#### - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##
#### SR: default data-driven fakes
##python susy-interface/plotmaker.py sos2l 2losEwkLow $T $O -l $RL --make datasig --plots perCateg -o SR --flags "--perBin $BLIND" $QUEUE
##python susy-interface/plotmaker.py sos2l 2losEwkMed $T $O -l $FL --make datasig --plots perCateg -o SR --flags "--perBin $BLIND" $QUEUE
##python susy-interface/plotmaker.py sos2l 2losEwkHig $T $O -l $FL --make datasig --plots perCateg -o SR --flags "--perBin $BLIND" $QUEUE
####
###### SR: fakes from MC
####python susy-interface/plotmaker.py sos2l 2losEwkLow $T $O -l $RL --make datasig --plots perCateg -p "data;prompt_.*;rares;fakes_matched_.*" -o SRmc --flags "--perBin $BLIND" $QUEUE
####python susy-interface/plotmaker.py sos2l 2losEwkMed $T $O -l $FL --make datasig --plots perCateg -p "data;prompt_.*;rares;fakes_matched_.*" -o SRmc --flags "--perBin $BLIND" $QUEUE
####python susy-interface/plotmaker.py sos2l 2losEwkHig $T $O -l $FL --make datasig --plots perCateg -p "data;prompt_.*;rares;fakes_matched_.*" -o SRmc --flags "--perBin $BLIND" $QUEUE
####
###### SR: semi-data-driven
#####python susy-interface/plotmaker.py sos2l 2losEwkLow $T $O -l $RL --make datasig --plots perCateg -p "data;prompt_.*;rares;fakes_applmc1;fakes_applmc2" -o SRsemi --flags "--perBin $BLIND --plotgroup fakes_applmc1+=fakes_applmc2" $QUEUE
#####python susy-interface/plotmaker.py sos2l 2losEwkMed $T $O -l $FL --make datasig --plots perCateg -p "data;prompt_.*;rares;fakes_applmc1;fakes_applmc2" -o SRsemi --flags "--perBin $BLIND --plotgroup fakes_applmc1+=fakes_applmc2" $QUEUE
#####python susy-interface/plotmaker.py sos2l 2losEwkHig $T $O -l $FL --make datasig --plots perCateg -p "data;prompt_.*;rares;fakes_applmc1;fakes_applmc2" -o SRsemi --flags "--perBin $BLIND --plotgroup fakes_applmc1+=fakes_applmc2" $QUEUE
####
####
####
###### Sideband
###### - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
####
###### SIDEBAND: MC fakes
####python susy-interface/plotmaker.py sos2l 2losEwkLow $T $O -l $RL --make datasig --plots perCateg -p "data;prompt_.*;rares;fakes_matched_.*" -o AR --flags "-X twoTight -E oneNotTight --perBin $BLIND" $QUEUE
####python susy-interface/plotmaker.py sos2l 2losEwkMed $T $O -l $FL --make datasig --plots perCateg -p "data;prompt_.*;rares;fakes_matched_.*" -o AR --flags "-X twoTight -E oneNotTight --perBin $BLIND" $QUEUE
####python susy-interface/plotmaker.py sos2l 2losEwkHig $T $O -l $FL --make datasig --plots perCateg -p "data;prompt_.*;rares;fakes_matched_.*" -o AR --flags "-X twoTight -E oneNotTight --perBin $BLIND" $QUEUE
####
###### SIDEBAND: MC fakes WITH SCALE FACTORS APPLIED
#####python susy-interface/plotmaker.py sos2l 2losEwkLow $T $O -l $RL --make datasig --plots perCateg -p "data;prompt_.*;rares;fakes_matchedBoth_.*" -o ARsc --flags "-X twoTight -E oneNotTight --perBin $BLIND" $QUEUE
#####python susy-interface/plotmaker.py sos2l 2losEwkMed $T $O -l $FL --make datasig --plots perCateg -p "data;prompt_.*;rares;fakes_matchedBoth_.*" -o ARsc --flags "-X twoTight -E oneNotTight --perBin $BLIND" $QUEUE
#####python susy-interface/plotmaker.py sos2l 2losEwkHig $T $O -l $FL --make datasig --plots perCateg -p "data;prompt_.*;rares;fakes_matchedBoth_.*" -o ARsc --flags "-X twoTight -E oneNotTight --perBin $BLIND" $QUEUE
####
###### SIDEBAND: MC fakes (1LNT)
####python susy-interface/plotmaker.py sos2l 2losEwkLow $T $O -l $RL --make datasig --plots perCateg -p "data;prompt_.*;rares;fakes_matched_.*" -o AR1F --flags "-X twoTight -E oneLNT --perBin $BLIND" $QUEUE
####python susy-interface/plotmaker.py sos2l 2losEwkMed $T $O -l $FL --make datasig --plots perCateg -p "data;prompt_.*;rares;fakes_matched_.*" -o AR1F --flags "-X twoTight -E oneLNT --perBin $BLIND" $QUEUE
####python susy-interface/plotmaker.py sos2l 2losEwkHig $T $O -l $FL --make datasig --plots perCateg -p "data;prompt_.*;rares;fakes_matched_.*" -o AR1F --flags "-X twoTight -E oneLNT --perBin $BLIND" $QUEUE
####
###### SIDEBAND: MC fakes (1LNT) WITH SCALE FACTOR APPLIED
#####python susy-interface/plotmaker.py sos2l 2losEwkLow $T $O -l $RL --make datasig --plots perCateg -p "data;prompt_.*;rares;fakes_matched1_.*" -o AR1Fsc --flags "-X twoTight -E oneLNT --perBin $BLIND" $QUEUE
#####python susy-interface/plotmaker.py sos2l 2losEwkMed $T $O -l $FL --make datasig --plots perCateg -p "data;prompt_.*;rares;fakes_matched1_.*" -o AR1Fsc --flags "-X twoTight -E oneLNT --perBin $BLIND" $QUEUE
#####python susy-interface/plotmaker.py sos2l 2losEwkHig $T $O -l $FL --make datasig --plots perCateg -p "data;prompt_.*;rares;fakes_matched1_.*" -o AR1Fsc --flags "-X twoTight -E oneLNT --perBin $BLIND" $QUEUE
####
###### SIDEBAND: MC fakes (2LNT)
####python susy-interface/plotmaker.py sos2l 2losEwkLow $T $O -l $RL --make datasig --plots perCateg -p "data;prompt_.*;rares;fakes_matched_.*" -o AR2F --flags "-X twoTight -E twoLNT --perBin $BLIND" $QUEUE
####python susy-interface/plotmaker.py sos2l 2losEwkMed $T $O -l $FL --make datasig --plots perCateg -p "data;prompt_.*;rares;fakes_matched_.*" -o AR2F --flags "-X twoTight -E twoLNT --perBin $BLIND" $QUEUE
####python susy-interface/plotmaker.py sos2l 2losEwkHig $T $O -l $FL --make datasig --plots perCateg -p "data;prompt_.*;rares;fakes_matched_.*" -o AR2F --flags "-X twoTight -E twoLNT --perBin $BLIND" $QUEUE
####
###### SIDEBAND: MC fakes (2LNT) WITH SCALE FACTOR APPLIED
#####python susy-interface/plotmaker.py sos2l 2losEwkLow $T $O -l $RL --make datasig --plots perCateg -p "data;prompt_.*;rares;fakes_matched2_.*" -o AR2Fsc --flags "-X twoTight -E twoLNT --perBin $BLIND" $QUEUE
#####python susy-interface/plotmaker.py sos2l 2losEwkMed $T $O -l $FL --make datasig --plots perCateg -p "data;prompt_.*;rares;fakes_matched2_.*" -o AR2Fsc --flags "-X twoTight -E twoLNT --perBin $BLIND" $QUEUE
#####python susy-interface/plotmaker.py sos2l 2losEwkHig $T $O -l $FL --make datasig --plots perCateg -p "data;prompt_.*;rares;fakes_matched2_.*" -o AR2Fsc --flags "-X twoTight -E twoLNT --perBin $BLIND" $QUEUE
##
##
##
##
##
##
##
##
#### STOP
#### -----------------------------------------------------------------
##
#### Search Regions
#### - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##
#### SR: default data-driven fakes
##python susy-interface/plotmaker.py sos2l 2losColLow $T $O -l $RL --make datasig --plots perCateg -o SR --flags "--perBin $BLIND" $QUEUE
##python susy-interface/plotmaker.py sos2l 2losColMed $T $O -l $FL --make datasig --plots perCateg -o SR --flags "--perBin $BLIND" $QUEUE
##python susy-interface/plotmaker.py sos2l 2losColHig $T $O -l $FL --make datasig --plots perCateg -o SR --flags "--perBin $BLIND" $QUEUE
##
#### SR: fakes from MC
###python susy-interface/plotmaker.py sos2l 2losColLow $T $O -l $RL --make datasig --plots perCateg -p "data;prompt_.*;rares;fakes_matched_.*" -o SRmc --flags "--perBin $BLIND" $QUEUE
###python susy-interface/plotmaker.py sos2l 2losColMed $T $O -l $FL --make datasig --plots perCateg -p "data;prompt_.*;rares;fakes_matched_.*" -o SRmc --flags "--perBin $BLIND" $QUEUE
###python susy-interface/plotmaker.py sos2l 2losColHig $T $O -l $FL --make datasig --plots perCateg -p "data;prompt_.*;rares;fakes_matched_.*" -o SRmc --flags "--perBin $BLIND" $QUEUE
##
#### SR: semi-data-driven
###python susy-interface/plotmaker.py sos2l 2losColLow $T $O -l $RL --make datasig --plots perCateg -p "data;prompt_.*;rares;fakes_applmc1;fakes_applmc2" -o SRsemi --flags "--perBin $BLIND --plotgroup fakes_applmc1+=fakes_applmc2" $QUEUE
###python susy-interface/plotmaker.py sos2l 2losColMed $T $O -l $FL --make datasig --plots perCateg -p "data;prompt_.*;rares;fakes_applmc1;fakes_applmc2" -o SRsemi --flags "--perBin $BLIND --plotgroup fakes_applmc1+=fakes_applmc2" $QUEUE
###python susy-interface/plotmaker.py sos2l 2losColHig $T $O -l $FL --make datasig --plots perCateg -p "data;prompt_.*;rares;fakes_applmc1;fakes_applmc2" -o SRsemi --flags "--perBin $BLIND --plotgroup fakes_applmc1+=fakes_applmc2" $QUEUE
##
##
##
##
##
#### Sideband
#### - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##
#### SIDEBAND: MC fakes
###python susy-interface/plotmaker.py sos2l 2losColLow $T $O -l $RL --make datasig --plots perCateg -p "data;prompt_.*;rares;fakes_matched_.*" -o AR --flags "-X twoTight -E oneNotTight --perBin $BLIND" $QUEUE
###python susy-interface/plotmaker.py sos2l 2losColMed $T $O -l $FL --make datasig --plots perCateg -p "data;prompt_.*;rares;fakes_matched_.*" -o AR --flags "-X twoTight -E oneNotTight --perBin $BLIND" $QUEUE
###python susy-interface/plotmaker.py sos2l 2losColHig $T $O -l $FL --make datasig --plots perCateg -p "data;prompt_.*;rares;fakes_matched_.*" -o AR --flags "-X twoTight -E oneNotTight --perBin $BLIND" $QUEUE
##
#### SIDEBAND: MC fakes WITH SCALE FACTORS APPLIED
###python susy-interface/plotmaker.py sos2l 2losColLow $T $O -l $RL --make datasig --plots perCateg -p "data;prompt_.*;rares;fakes_matchedBoth_.*" -o ARsc --flags "-X twoTight -E oneNotTight --perBin $BLIND" $QUEUE
###python susy-interface/plotmaker.py sos2l 2losColMed $T $O -l $FL --make datasig --plots perCateg -p "data;prompt_.*;rares;fakes_matchedBoth_.*" -o ARsc --flags "-X twoTight -E oneNotTight --perBin $BLIND" $QUEUE
###python susy-interface/plotmaker.py sos2l 2losColHig $T $O -l $FL --make datasig --plots perCateg -p "data;prompt_.*;rares;fakes_matchedBoth_.*" -o ARsc --flags "-X twoTight -E oneNotTight --perBin $BLIND" $QUEUE
##
#### SIDEBAND: MC fakes (1LNT)
###python susy-interface/plotmaker.py sos2l 2losColLow $T $O -l $RL --make datasig --plots perCateg -p "data;prompt_.*;rares;fakes_matched_.*" -o AR1F --flags "-X twoTight -E oneLNT --perBin $BLIND" $QUEUE
###python susy-interface/plotmaker.py sos2l 2losColMed $T $O -l $FL --make datasig --plots perCateg -p "data;prompt_.*;rares;fakes_matched_.*" -o AR1F --flags "-X twoTight -E oneLNT --perBin $BLIND" $QUEUE
###python susy-interface/plotmaker.py sos2l 2losColHig $T $O -l $FL --make datasig --plots perCateg -p "data;prompt_.*;rares;fakes_matched_.*" -o AR1F --flags "-X twoTight -E oneLNT --perBin $BLIND" $QUEUE
##
#### SIDEBAND: MC fakes (1LNT) WITH SCALE FACTOR APPLIED
###python susy-interface/plotmaker.py sos2l 2losColLow $T $O -l $RL --make datasig --plots perCateg -p "data;prompt_.*;rares;fakes_matched1_.*" -o AR1Fsc --flags "-X twoTight -E oneLNT --perBin $BLIND" $QUEUE
###python susy-interface/plotmaker.py sos2l 2losColMed $T $O -l $FL --make datasig --plots perCateg -p "data;prompt_.*;rares;fakes_matched1_.*" -o AR1Fsc --flags "-X twoTight -E oneLNT --perBin $BLIND" $QUEUE
###python susy-interface/plotmaker.py sos2l 2losColHig $T $O -l $FL --make datasig --plots perCateg -p "data;prompt_.*;rares;fakes_matched1_.*" -o AR1Fsc --flags "-X twoTight -E oneLNT --perBin $BLIND" $QUEUE
##
#### SIDEBAND: MC fakes (2LNT)
###python susy-interface/plotmaker.py sos2l 2losColLow $T $O -l $RL --make datasig --plots perCateg -p "data;prompt_.*;rares;fakes_matched_.*" -o AR2F --flags "-X twoTight -E twoLNT --perBin $BLIND" $QUEUE
###python susy-interface/plotmaker.py sos2l 2losColMed $T $O -l $FL --make datasig --plots perCateg -p "data;prompt_.*;rares;fakes_matched_.*" -o AR2F --flags "-X twoTight -E twoLNT --perBin $BLIND" $QUEUE
###python susy-interface/plotmaker.py sos2l 2losColHig $T $O -l $FL --make datasig --plots perCateg -p "data;prompt_.*;rares;fakes_matched_.*" -o AR2F --flags "-X twoTight -E twoLNT --perBin $BLIND" $QUEUE
##
#### SIDEBAND: MC fakes (2LNT) WITH SCALE FACTOR APPLIED
###python susy-interface/plotmaker.py sos2l 2losColLow $T $O -l $RL --make datasig --plots perCateg -p "data;prompt_.*;rares;fakes_matched2_.*" -o AR2Fsc --flags "-X twoTight -E twoLNT --perBin $BLIND" $QUEUE
###python susy-interface/plotmaker.py sos2l 2losColMed $T $O -l $FL --make datasig --plots perCateg -p "data;prompt_.*;rares;fakes_matched2_.*" -o AR2Fsc --flags "-X twoTight -E twoLNT --perBin $BLIND" $QUEUE
###python susy-interface/plotmaker.py sos2l 2losColHig $T $O -l $FL --make datasig --plots perCateg -p "data;prompt_.*;rares;fakes_matched2_.*" -o AR2Fsc --flags "-X twoTight -E twoLNT --perBin $BLIND" $QUEUE
##
##
##
##
##
##
##
##
#### 2L SS
#### =================================================================
##
##
#### Search Regions
#### - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##
#### SR: default data-driven fakes
##python susy-interface/plotmaker.py sos2l 2lss $T $O -l $FL --make datasig --plots perCateg -o SR --flags "--perBin $BLIND" $QUEUE
#python susy-interface/plotmaker.py sos2l 2lss $T $O -l $FL --make datasig --plots testing -o SR --flags "--perBin $BLIND" $QUEUE
##
#### SR: fakes from MC
###python susy-interface/plotmaker.py sos2l 2lss $T $O -l $FL --make datasig --plots perCateg -p "data;prompt_.*;rares;fakes_matched_.*" -o SRmc --flags "--perBin $BLIND" $QUEUE
##
#### SR: semi-data-driven
##python susy-interface/plotmaker.py sos2l 2lss $T $O -l $FL --make datasig --plots perCateg -p "data;prompt_.*;rares;fakes_applmc1;fakes_applmc2" -o SRsemi --flags "--perBin $BLIND --plotgroup fakes_applmc1+=fakes_applmc2" $QUEUE
python susy-interface/plotmaker.py sos2l 2lss $T $O -l $FL --make datasig --plots testing -p "data;prompt_.*;rares;fakes_applmc1;fakes_applmc2" -o SRsemi --flags "--perBin $BLIND --plotgroup fakes_applmc1+=fakes_applmc2" $QUEUE
##
##
##
#### Sideband
#### - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##
#### SIDEBAND: MC fakes
###python susy-interface/plotmaker.py sos2l 2lss $T $O -l $FL --make datasig --plots perCateg -p "data;prompt_.*;rares;fakes_matched_.*" -o AR --flags "-X twoTight -E oneNotTight --perBin $BLIND" $QUEUE
##
#### SIDEBAND: MC fakes WITH SCALE FACTORS APPLIED
###python susy-interface/plotmaker.py sos2l 2lss $T $O -l $FL --make datasig --plots perCateg -p "data;prompt_.*;rares;fakes_matchedBoth_.*" -o ARsc --flags "-X twoTight -E oneNotTight --perBin $BLIND" $QUEUE
##
#### SIDEBAND: MC fakes (1LNT)
###python susy-interface/plotmaker.py sos2l 2lss $T $O -l $FL --make datasig --plots perCateg -p "data;prompt_.*;rares;fakes_matched_.*" -o AR1F --flags "-X twoTight -E oneLNT --perBin $BLIND" $QUEUE
##
#### SIDEBAND: MC fakes (1LNT) WITH SCALE FACTOR APPLIED
###python susy-interface/plotmaker.py sos2l 2lss $T $O -l $FL --make datasig --plots perCateg -p "data;prompt_.*;rares;fakes_matched1_.*" -o AR1Fsc --flags "-X twoTight -E oneLNT --perBin $BLIND" $QUEUE
##
#### SIDEBAND: MC fakes (2LNT)
###python susy-interface/plotmaker.py sos2l 2lss $T $O -l $FL --make datasig --plots perCateg -p "data;prompt_.*;rares;fakes_matched_.*" -o AR2F --flags "-X twoTight -E twoLNT --perBin $BLIND" $QUEUE
##
#### SIDEBAND: MC fakes (2LNT) WITH SCALE FACTOR APPLIED
###python susy-interface/plotmaker.py sos2l 2lss $T $O -l $FL --make datasig --plots perCateg -p "data;prompt_.*;rares;fakes_matched2_.*" -o AR2Fsc --flags "-X twoTight -E twoLNT --perBin $BLIND" $QUEUE
##
##
##
##
##
##
##
##
#### 3L SIGNAL REGION
#### =================================================================
##
##T="/data1/peruzzi/trees_SOS_110917_noVtx" ## do NOT give a trailing /
##
#### default data-driven fakes
###python susy-interface/plotmaker.py sos3l 3lLow $T $O -l $RL --make datasig --plots perCateg -o SR --flags "--perBin $BLIND" -p "prompt_.*;rares;fakes_appldata"   $QUEUE
###python susy-interface/plotmaker.py sos3l 3lMed $T $O -l $FL --make datasig --plots perCateg -o SR --flags "--perBin $BLIND" -p "prompt_.*;rares;fakes_appldata"   $QUEUE
##
#### matched MC fakes
##python susy-interface/plotmaker.py sos3l 3lLow $T $O -l $RL --make datasig --plots perCateg -o SRmc --flags "--perBin $BLIND" -p "prompt_.*;rares;fakes_matched_.*" $QUEUE
##python susy-interface/plotmaker.py sos3l 3lMed $T $O -l $FL --make datasig --plots perCateg -o SRmc --flags "--perBin $BLIND" -p "prompt_.*;rares;fakes_matched_.*" $QUEUE
##
##
##
##
##
##
#### 2L CR DY
#### =================================================================
##
##T="/data1/botta/trees_SOS_010217" ## do NOT give a trailing /
#### wanna consider removing the mcc and thus the SF ? 
##
#### default data-driven fakes
##python susy-interface/plotmaker.py sos2l dyLow $T $O -l $RL --make datasig --plots perCateg -o SR --flags "--perBin $BLIND" $QUEUE
##python susy-interface/plotmaker.py sos2l dyMed $T $O -l $FL --make datasig --plots perCateg -o SR --flags "--perBin $BLIND" $QUEUE
##
##
#### 2L CR TT
#### =================================================================
##
#### wanna consider removing the mcc and thus the SF ? 
##
#### default data-driven fakes
##python susy-interface/plotmaker.py sos2l ttLow $T $O -l $RL --make datasig --plots perCateg -o SR --flags "--perBin $BLIND" $QUEUE
##python susy-interface/plotmaker.py sos2l ttMed $T $O -l $FL --make datasig --plots perCateg -o SR --flags "--perBin $BLIND" $QUEUE
##
##
#### 2L CR VV
#### =================================================================
##
#### default data-driven fakes
##python susy-interface/plotmaker.py sos2l vvLow $T $O -l $RL --make datasig --plots perCateg -o SR --flags "--perBin $BLIND" $QUEUE
##python susy-interface/plotmaker.py sos2l vvMed $T $O -l $FL --make datasig --plots perCateg -o SR --flags "--perBin $BLIND" $QUEUE
##
##
#### 2L CR WZ
#### =================================================================
##
##T="/data1/peruzzi/trees_SOS_110917_noVtx" ## do NOT give a trailing /
##
#### default data-driven fakes
###python susy-interface/plotmaker.py sos3l wzLow $T $O -l $RL --make datasig --plots perCateg -o SR --flags "--perBin $BLIND" $QUEUE
###python susy-interface/plotmaker.py sos3l wzMed $T $O -l $FL --make datasig --plots perCateg -o SR --flags "--perBin $BLIND" $QUEUE

## matched MC fakes
##python susy-interface/plotmaker.py sos3l wzLow $T $O -l $RL --make datasig --plots perCateg -o SRmc --flags "--perBin $BLIND" -p "prompt_.*;rares;fakes_matched_.*" $QUEUE
##python susy-interface/plotmaker.py sos3l wzMed $T $O -l $FL --make datasig --plots perCateg -o SRmc --flags "--perBin $BLIND" -p "prompt_.*;rares;fakes_matched_.*" $QUEUE



