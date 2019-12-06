################################
#  use mcEfficiencies.py to make plots of the fake rate
################################

ANALYSIS=$1; if [[ "$1" == "" ]]; then exit 1; fi; shift;
case $ANALYSIS in
sos) 
    YEAR=$1; shift; 
    case $YEAR in 2016) L=35.9;; 2017) L=41.5;; 2018) L=59.7;; esac
    T=/eos/cms/store/user/ipapaver/FRNtuples_${YEAR}
    #T=/eos/cms/store/cmst3/group/tthlep/peruzzi/NanoTrees_SOS_230819_v5/$YEAR
    #T2=/eos/cms/store/cmst3/user/vtavolar/susySOS/friends_fromv5/$YEAR/recleaner_mc_new/
    #test -d /tmp/$USER/TREES_ttH_FR_nano_v5/$YEAR && T="/tmp/$USER/TREES_ttH_FR_nano_v5/$YEAR -P $T"
    #test -d /data/$USER/TREES_ttH_FR_nano_v5/$YEAR && T="/data/$USER/TREES_ttH_FR_nano_v5/$YEAR -P $T"
    #hostname | grep -q cmsco01 && T=/data1/gpetrucc/TREES_94X_FR_240518
    #hostname | grep -q cmsphys10 && T=/data/g/gpetrucc/TREES_94X_FR_240518
    PBASE="~/www/FakeRate_MC_QCDMuTriggersBiasStudy/104X/${ANALYSIS}/fr-mc/bTagDeepCSV_study_MinimalSelection/$YEAR/JetBTagDeepCSV0p12_FNT"
    TREE="NanoAOD";
    ;;
susy) 
    echo "NOT UP TO DATE"; exit 1; 
    ;;
*)if [[ "$1" == "" ]]; then exit 1; fi; shift;
    echo "Unknown analysis '$ANALYSIS'";
    exit 1;
esac;


#BCORE=" --s2v --tree ${TREE} susy-sos-v2-clean/lepton-fr/lepton_mca${YEAR}_frstudies_LFMatch3.txt susy-sos-v2-clean/lepton-fr/sos_fr_den.txt"
BCORE=" --s2v --tree ${TREE} susy-sos/lepton-fr/mca-qcd1l-mc.txt susy-sos/lepton-fr/qcd1l.txt "
#BCORE="${BCORE} --Fs /eos/cms/store/cmst3/user/vtavolar/susySOS/friends_fromv5/$YEAR/recleaner_mc_new/"
BCORE="${BCORE}  --Fs {P}/Friends_ObjTagger"
BASE="python mcEfficiencies.py $BCORE --ytitle 'Fake rate'"
PLOTTER="python mcPlots.py $BCORE   "

#Num='muon_tight'


BG=" -j 8 "; if [[ "$1" == "-b" ]]; then BG=" -j 4 & "; shift; fi

#if [[ "$3" == "muon"]]; then echo "something" ; fi #Num='muon_tight';fi;
#if [[ "$LEPTON" == "muon" ]]; then Num='muon_tight'; else Num='ele_tight'; fi;


#B0="$BASE -P $T  susy-sos-v2-clean/lepton-fr/sos_fr_num.txt susy-sos-v2-clean/lepton-fr/make_fake_rates_xvars.txt --groupBy cut " 
B0="$BASE -P $T  susy-sos/lepton-fr/qcd1l_num.txt susy-sos/lepton-fr/make_fake_rates_xvars.txt --groupBy cut " 

B0="$B0" #--showRatio --ratioRange 0.00 1.99   --yrange 0 0.35 " 
B1="${PLOTTER} -P $T susy-sos-v2-clean/lepton-fr/make_fake_rates_plots.txt"
B1="$B1 --showRatio --maxRatioRange 0 2 --plotmode=norm -f "
XVAR2="'pt_fine'"
XVAR1="'Jetpt_fine'"

CommonDen="-E ^mu_den$"
MuDen="--sP muon_tight -E ^mu $CommonDen"
ElDen="--sP ele_tight $CommonDen -E ^ele$"
MuBarDen="--sP muon_tight_Barrel $CommonDen -E ^mu$ -E ^barrel$"
ElBarDen="--sP ele_tight_Barrel  $CommonDen -E ^ele$ -E ^barrel$"
MuEndDen="--sP muon_tight_End $CommonDen -E ^mu$ -E ^endcap$"
ElEndDen="--sP ele_tight_End $CommonDen -E ^ele$ -E ^endcap$"

MuFakeVsPt="$MuDen --sP $XVAR2" 
ElFakeVsPt="$ElDen --sP $XVAR2"
MuFakeVsPt_Barr="$MuBarDen --sP $XVAR2" 
ElFakeVsPt_Barr="$ElBarDen --sP $XVAR2"
MuFakeVsPt_End="$MuEndDen --sP $XVAR2" 
ElFakeVsPt_End="$ElEndDen --sP $XVAR2"  
#MuFakeVsPtLongBin="$MuDen ${BDen} --sP '${ptJI}_${XVar}_coarselongbin' --sp TT_red   --xcut 10 999 --xline 15 " 
#ElFakeVsPtLongBin="$ElDen ${BDen} --sP '${ptJI}_${XVar}_coarselongbin' --sp TT_redNC --xcut 10 999 --xline 15 " 

#Nominal Test bTagDeepCSV Cut FO definition
echo "( $B0 --legend=TR $MuFakeVsPt -E ^JetBTagCSV_Denom$ -p QCDMu_bjets,QCDMu_cjets,QCDMu_ljets -A 'entry point' trigger 'HLT_Mu3_PFJet40' -A 'entry point' nMuons 'nMuon<=1' --xcut 0 50 --yrange 0 1 -A 'entry point' recoptfortrigger 'LepGood_pt>3.0' -A 'entry point' eta 'abs(LepGood_eta)<1.2' -L susy-sos/lepton-fr/frPuReweight.cc -W 'puwMu3_PFJet40_2018(PV_npvsGood)' -o $PBASE/QCD_HLT_Mu3_PFJet40_Barrel.root  ${BG})"

#echo "echo\" ---- NOMINAL CUTS ----- \""

#echo "( $B0 --legend=TR $MuFakeVsPt -p QCDMu_red,QCDMu_bjets,QCDMu_cjets,QCDMu_ljets -A 'entry point' trigger 'HLT_Mu8' -A 'entry point' nMuons 'nMuon<=1' --xcut 13 45 --yrange 0 1 -A 'entry point' recoptfortrigger 'LepGood_pt>13.0' -A 'entry point' eta 'abs(LepGood_eta)<1.2' -L susy-sos/lepton-fr/frPuReweight.cc -W 'puwMu8_2018(PV_npvsGood)' -o $PBASE/QCD_HLT_Mu8_Barrel.root  ${BG})"
#
#echo "( $B0 --legend=TR $MuFakeVsPt -p QCDMu_red,QCDMu_bjets,QCDMu_cjets,QCDMu_ljets -A 'entry point' trigger 'HLT_Mu3_PFJet40' -A 'entry point' nMuons 'nMuon<=1' --xcut 0 30 --yrange 0 1  -A 'entry point' recoptfortrigger 'LepGood_pt>3.0 && LepGood_awayJet_pt>45.0' -A 'entry point' eta 'abs(LepGood_eta)<1.2' -L susy-sos/lepton-fr/frPuReweight.cc -W 'puwMu3_PFJet40_2018(PV_npvsGood)' -o $PBASE/QCD_HLT_Mu3_PFJet40_Barrel.root  ${BG})"
#
#
##echo "echo\" ---- TIGHT Jet PT cuts 45 GeV ----\""
#
#echo "( $B0 --legend=TR $MuFakeVsPt -p QCDMu_red,QCDMu_bjets,QCDMu_cjets,QCDMu_ljets -A 'entry point' trigger 'HLT_Mu8' -A 'entry point' nMuons 'nMuon<=1' --yrange 0 1 -A 'entry point' recoptfortrigger 'LepGood_pt>13.0 && LepGood_awayJet_pt>45.0' -A 'entry point' eta 'abs(LepGood_eta)<1.2' -L susy-sos/lepton-fr/frPuReweight.cc -W 'puwMu8_2018(PV_npvsGood)' -o $PBASE/AwayJetPt45/QCD_HLT_Mu8_Barrel.root  ${BG})"
#
#echo "( $B0 --legend=TR $MuFakeVsPt -p QCDMu_red,QCDMu_bjets,QCDMu_cjets,QCDMu_ljets -A 'entry point' trigger 'HLT_Mu3_PFJet40' -A 'entry point' nMuons 'nMuon<=1' --yrange 0 1  -A 'entry point' recoptfortrigger 'LepGood_pt>3.0 && LepGood_awayJet_pt>45.0' -A 'entry point' eta 'abs(LepGood_eta)<1.2' -L susy-sos/lepton-fr/frPuReweight.cc -W 'puwMu3_PFJet40_2018(PV_npvsGood)' -o $PBASE/AwayJetPt45/QCD_HLT_Mu3_PFJet40_Barrel.root  ${BG})"
#
##echo "echo\" ---- TIGHT Jet PT cuts 50 GeV ----\""
#
#echo "( $B0 --legend=TR $MuFakeVsPt -p QCDMu_red,QCDMu_bjets,QCDMu_cjets,QCDMu_ljets -A 'entry point' trigger 'HLT_Mu8' -A 'entry point' nMuons 'nMuon<=1'  --yrange 0 1 -A 'entry point' recoptfortrigger 'LepGood_pt>13.0 && LepGood_awayJet_pt>50.0' -A 'entry point' eta 'abs(LepGood_eta)<1.2' -L susy-sos/lepton-fr/frPuReweight.cc -W 'puwMu8_2018(PV_npvsGood)' -o $PBASE/AwayJet50/QCD_HLT_Mu8_Barrel.root  ${BG})"
#
#echo "( $B0 --legend=TR $MuFakeVsPt -p QCDMu_red,QCDMu_bjets,QCDMu_cjets,QCDMu_ljets -A 'entry point' trigger 'HLT_Mu3_PFJet40' -A 'entry point' nMuons 'nMuon<=1' --yrange 0 1  -A 'entry point' recoptfortrigger 'LepGood_pt>3.0 && LepGood_awayJet_pt>50.0' -A 'entry point' eta 'abs(LepGood_eta)<1.2' -L susy-sos/lepton-fr/frPuReweight.cc -W 'puwMu3_PFJet40_2018(PV_npvsGood)' -o $PBASE/AwayJet50/QCD_HLT_Mu3_PFJet40_Barrel.root  ${BG})"
#
##echo "echo\" ---- Matching to Trigger Jet Obj ----\""
#
#echo "( $B0 --legend=TR $MuFakeVsPt -p QCDMu_red,QCDMu_bjets,QCDMu_cjets,QCDMu_ljets -A 'entry point' trigger 'HLT_Mu8' -A 'entry point' nMuons 'nMuon<=1'  --yrange 0 1 -E ^triggObj_matchJet$ -A 'entry point' recoptfortrigger 'LepGood_pt>13.0' -A 'entry point' eta 'abs(LepGood_eta)<1.2' -L susy-sos/lepton-fr/frPuReweight.cc -W 'puwMu8_2018(PV_npvsGood)' -o $PBASE/MatchingJetTrigObj/QCD_HLT_Mu8_Barrel.root  ${BG})"
#
#echo "( $B0 --legend=TR $MuFakeVsPt -p QCDMu_red,QCDMu_bjets,QCDMu_cjets,QCDMu_ljets -A 'entry point' trigger 'HLT_Mu3_PFJet40' -A 'entry point' nMuons 'nMuon<=1'  --yrange 0 1  -E ^triggObj_matchJet$ -A 'entry point' recoptfortrigger 'LepGood_pt>3.0 && LepGood_awayJet_pt>45.0' -A 'entry point' eta 'abs(LepGood_eta)<1.2' -L susy-sos/lepton-fr/frPuReweight.cc -W 'puwMu3_PFJet40_2018(PV_npvsGood)' -o $PBASE/MatchingJetTrigObj/QCD_HLT_Mu3_PFJet40_Barrel.root  ${BG})"
#
#
##echo "echo\" ---- Matching to Trigger Jet Obj and Tight Jet PT 45 GeV ----\"" 
#
#echo "( $B0 --legend=TR $MuFakeVsPt -p QCDMu_red,QCDMu_bjets,QCDMu_cjets,QCDMu_ljets -A 'entry point' trigger 'HLT_Mu8' -A 'entry point' nMuons 'nMuon<=1'  --yrange 0 1 -E ^triggObj_matchJet$ -A 'entry point' recoptfortrigger 'LepGood_pt>13.0 && LepGood_awayJet_pt>45.0' -A 'entry point' eta 'abs(LepGood_eta)<1.2' -L susy-sos/lepton-fr/frPuReweight.cc -W 'puwMu8_2018(PV_npvsGood)' -o $PBASE/MatchingJetTrigObj_AwayJetPt45/QCD_HLT_Mu8_Barrel.root  ${BG})"
#
#echo "( $B0 --legend=TR $MuFakeVsPt -p QCDMu_red,QCDMu_bjets,QCDMu_cjets,QCDMu_ljets -A 'entry point' trigger 'HLT_Mu3_PFJet40' -A 'entry point' nMuons 'nMuon<=1'  --yrange 0 1  -E ^triggObj_matchJet$ -A 'entry point' recoptfortrigger 'LepGood_pt>3.0 && LepGood_awayJet_pt>45.0' -A 'entry point' eta 'abs(LepGood_eta)<1.2' -L susy-sos/lepton-fr/frPuReweight.cc -W 'puwMu3_PFJet40_2018(PV_npvsGood)' -o $PBASE/MatchingJetTrigObj_AwayJetPt45/QCD_HLT_Mu3_PFJet40_Barrel.root  ${BG})"
#
##echo "echo\" ---- Matching to Trigger Jet Obj and Tight Jet PT 50 GeV ----\""
#
#echo "( $B0 --legend=TR $MuFakeVsPt -p QCDMu_red,QCDMu_bjets,QCDMu_cjets,QCDMu_ljets -A 'entry point' trigger 'HLT_Mu8' -A 'entry point' nMuons 'nMuon<=1' --yrange 0 1 -E ^triggObj_matchJet$ -A 'entry point' recoptfortrigger 'LepGood_pt>13.0 && LepGood_awayJet_pt>50.0' -A 'entry point' eta 'abs(LepGood_eta)<1.2' -L susy-sos/lepton-fr/frPuReweight.cc -W 'puwMu8_2018(PV_npvsGood)' -o $PBASE/MatchingJetTrigObj_AwayJetPt50/QCD_HLT_Mu8_Barrel.root  ${BG})"
#
#echo "( $B0 --legend=TR $MuFakeVsPt -p QCDMu_red,QCDMu_bjets,QCDMu_cjets,QCDMu_ljets -A 'entry point' trigger 'HLT_Mu3_PFJet40' -A 'entry point' nMuons 'nMuon<=1' --yrange 0 1  -E ^triggObj_matchJet$ -A 'entry point' recoptfortrigger 'LepGood_pt>3.0 && LepGood_awayJet_pt>50.0' -A 'entry point' eta 'abs(LepGood_eta)<1.2' -L susy-sos/lepton-fr/frPuReweight.cc -W 'puwMu3_PFJet40_2018(PV_npvsGood)' -o $PBASE/MatchingJetTrigObj_AwayJetPt50/QCD_HLT_Mu3_PFJet40_Barrel.root  ${BG})"


##echo "( $B0 --legend=TL $MuFakeVsPt -p WJets_light,DY_jets_light,TT_jets_light -o $PBASE/$what/MuFakeVsPt_InclusiveEta_LF.root  ${BG})"
##echo "( $B0 --legend=TL $ElFakeVsPt -p WJets_light,DY_jets_light,TT_jets_light -o $PBASE/$what/EleFakeVsPt_InclusiveEta_LF.root  ${BG})"
##echo "( $B0 --legend=TL $MuFakeVsPt_Barr -p WJets_light,DY_jets_light,TT_jets_light -o $PBASE/$what/MuFakeVsPt_Barrel_LF.root  ${BG})"
##echo "( $B0 --legend=TL $ElFakeVsPt_Barr -p WJets_light,DY_jets_light,TT_jets_light -o $PBASE/$what/EleFakeVsPt_Barrel_LF.root  ${BG})"
##echo "( $B0 --legend=TL $MuFakeVsPt_End -p WJets_light,DY_jets_light,TT_jets_light -o $PBASE/$what/MuFakeVsPt_Endcap_LF.root  ${BG})"
##echo "( $B0 --legend=TL $ElFakeVsPt_End -p WJets_light,DY_jets_light,TT_jets_light -o $PBASE/$what/EleFakeVsPt_Endcap_LF.root  ${BG})"
##
##echo "( $B0 --legend=TL $MuFakeVsPt -p WJets_HF,DY_jets_HF,TT_jets_HF -o $PBASE/$what/MuFakeVsPt_InclusiveEta_HF.root  ${BG})"
##echo "( $B0 --legend=TL $ElFakeVsPt -p WJets_HF,DY_jets_HF,TT_jets_HF -o $PBASE/$what/EleFakeVsPt_InclusiveEta_HF.root  ${BG})"
##echo "( $B0 --legend=TL $MuFakeVsPt_Barr -p WJets_HF,DY_jets_HF,TT_jets_HF -o $PBASE/$what/MuFakeVsPt_Barrel_HF.root  ${BG})"
##echo "( $B0 --legend=TL $ElFakeVsPt_Barr -p WJets_HF,DY_jets_HF,TT_jets_HF -o $PBASE/$what/EleFakeVsPt_Barrel_HF.root  ${BG})"
##echo "( $B0 --legend=TL $MuFakeVsPt_End -p WJets_HF,DY_jets_HF,TT_jets_HF -o $PBASE/$what/MuFakeVsPt_Endcap_HF.root  ${BG})"
##echo "( $B0 --legend=BR $ElFakeVsPt_End -p WJets_HF,DY_jets_HF,TT_jets_HF -o $PBASE/$what/EleFakeVsPt_Endcap_HF.root  ${BG})"
##

