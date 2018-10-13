#!/bin/bash

P=`pwd`

## direct commands to be executed from the macros directory
cd /afs/cern.ch/user/c/cheidegg/ec/CMSSW_9_4_3/src/CMGTools/TTHAnalysis/macros/
cmsenv

## tree dir
T="/data1/peruzzi/trees_SOS_030518"
TT="/data1/cheidegg/trees_SOS_030518_newWjets"
#TT="/data1/cheidegg/trees_SOS_030518_jetsWithEtaAndPhi"

#T="/data1/botta/trees_SOS_010217/"
#TT="/data1/cheidegg/trees_SOS_010217/"

## recleaner
N="0_both3dlooseClean_v2"
python prepareEventVariablesFriendTree.py --tra2 --tree treeProducerSusyMultilepton -I CMGTools.TTHAnalysis.tools.susySosReCleaner -m both3dloose -m ipjets -N 1000000 $T $TT/$N -n -j 8

## event weights
M="0_eventShapeWeight_v3"
#python prepareEventVariablesFriendTree.py --tra2 --tree treeProducerSusyMultilepton -I CMGTools.TTHAnalysis.tools.WeightsForSystematics -m systematics -N 1000000000 -F sf/t $TT/$N/evVarFriend_{cname}.root -j 8 $T  $TT/$M -n

## btag weights fullsim
K="0_eventBTagWeight_v3"
#python prepareEventVariablesFriendTree.py --tra2 --tree treeProducerSusyMultilepton -I CMGTools.TTHAnalysis.tools.susySosReCleaner -m bTagEventWeightFullSim -N 1000000 -F sf/t $TT/$N/evVarFriend_{cname}.root -j 8 $T $TT/$K -n

## btag weights fullsim with full shape
K="0_eventBTagWeight_v3"
#python prepareEventVariablesFriendTree.py --tra2 --tree treeProducerSusyMultilepton -I CMGTools.TTHAnalysis.tools.susySosReCleaner -m eventBTagWeight -N 1000000 -F sf/t $T/$N/evVarFriend_{cname}.root $T $TT/$K -n -j 8

## btag weight fastsim
L="0_eventBTagWeightFS_v2"
#python prepareEventVariablesFriendTree.py --tra2 --tree treeProducerSusyMultilepton -I CMGTools.TTHAnalysis.tools.susySosReCleaner -m bTagEventWeightFastSim -N 1000000 -F sf/t $TT/$N/evVarFriend_{cname}.root -j 8 $T $TT/$L -n

## pileup weights per sample
L="0_pileup_v1"
#python prepareEventVariablesFriendTree.py --tra2 --tree treeProducerSusyMultilepton -I CMGTools.TTHAnalysis.tools.functionsTTH -m vtxWeight -N 100000000 -j 8 $T $TT/$L -n

cd $P
