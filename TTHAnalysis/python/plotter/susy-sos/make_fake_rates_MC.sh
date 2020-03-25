################################
#  use mcEfficiencies.py to make plots of the fake rate
################################

#usage: ./susy-sos/make_fake_rate_MC.sh sos YEAR LEPTON TRIGGER
# will print commands per lepton and trigger for Barrel and Endcap 

ANALYSIS=$1; if [[ "$1" == "" ]]; then exit 1; fi; shift;
case $ANALYSIS in
sos) 
    YEAR=$1; shift; 
    case $YEAR in 2016) L=35.9;; 2017) L=41.5;; 2018) L=59.7;; esac
    T=/eos/cms/store/user/ipapaver/FRNtuples_${YEAR}
    TREE="NanoAOD";
    ;;
susy) 
    echo "NOT UP TO DATE"; exit 1; 
    ;;
*)if [[ "$1" == "" ]]; then exit 1; fi; shift;
    echo "Unknown analysis '$ANALYSIS'";
    exit 1;
esac;



LEPTON=$1
TRIGGER=$2; if [[ "$2" == "" ]]; then exit 1; fi
PBASE="~/www/FakeRate_MC_QCDMuTriggersBiasStudy_${YEAR}/testSetUp/fr-mc/${LEPTON}_newFO_TuneFO/"
BCORE=" --s2v --tree ${TREE} susy-sos/lepton-fr/mca-qcd1l-mc.txt susy-sos/lepton-fr/qcd1l.txt "
BCORE="${BCORE}  --Fs {P}/FRiendTreesObjTaggers_${YEAR}"
BASE="python mcEfficiencies.py $BCORE --ytitle 'Fake rate'"
PLOTTER="python mcPlots.py $BCORE   "

#Num='muon_tight'
BG=" -j 8 "; if [[ "$1" == "-b" ]]; then BG=" -j 4 & "; shift; fi

B0="$BASE -P $T  susy-sos/lepton-fr/qcd1l_num.txt susy-sos/lepton-fr/make_fake_rates_xvars.txt --groupBy cut " 

B0="$B0" #--showRatio --ratioRange 0.00 1.99   --yrange 0 0.35 " 
#B1="${PLOTTER} -P $T susy-sos-v2-clean/lepton-fr/make_fake_rates_plots.txt"
#B1="$B1 --showRatio --maxRatioRange 0 2 --plotmode=norm -f "
XVAR2="'pt_fine'"
XVAR1="'Jetpt_fine'"

case $LEPTON in
    mu) 
      CommonDen="-E ^mu_den_noBTag$ -E ^relIso$"
      DEN="--sP muon_tight -E ^mu$ $CommonDen";
      VAR="$DEN --sP $XVAR2";
      nLep="nMuon";
      PROCESS="QCDMu_bjets,QCDMu_cjets,QCDMu_ljets";;
    el)
      CommonDen="-E ^el_den_noBTag$ -E ^relIso$"
      DEN="--sP ele_tight -E ^el$ $CommonDen ";
      VAR="$DEN --sP $XVAR2";
      nLep="nElectron";
      PROCESS="QCDEl_red,QCDEl_bjets,QCDEl_cjets,QCDEl_ljets";;
esac

case $TRIGGER in
    Mu3_PFJet40) 
        LepPt="-A 'entry point' lepPt 'LepGood_pt>3'"
        TRIGGERName="$TRIGGER";;
    Mu8)         
        LepPt="-A 'entry point' lepPt 'LepGood_pt>8'"
        TRIGGERName="$TRIGGER";;
    Ele8)
        TRIGGER="Ele8_CaloIdM_TrackIdM_PFJet30" 
        LepPt="-A 'entry point' lepPt 'LepGood_pt>8'"
        TRIGGERName="$TRIGGER";;
    PFJet) 
        TRIGGER="PFJet25||HLT_PFJet40||HLT_PFJet60||HLT_PFJet80||HLT_PFJet80||HLT_PFJet140||HLT_PFJet200||HLT_PFJet260"
        TRIGGERName="PFJet";;
esac;


#Nominal Test bTagDeepCSV Cut FO definition
echo "( $B0 --legend=TR $VAR  -p $PROCESS -A 'entry point' trigger 'HLT_${TRIGGER}' -A 'entry point' nLep '$nLep<=1' --xcut 0 50 --yrange 0 1 $LepPt -A 'entry point' awayJetPt 'LepGood_awayJet_pt>50' -A 'entry point' eta 'abs(LepGood_eta)<1.2' -L susy-sos/lepton-fr/frPuReweight.cc -W 'puw${TRIGGERName}_${YEAR}(PV_npvsGood)' -o $PBASE/QCD_${TRIGGERName}_Barrel.root  ${BG})"

echo "( $B0 --legend=TR $VAR  -p $PROCESS -A 'entry point' trigger 'HLT_${TRIGGER}' -A 'entry point' nLep '$nLep<=1' --xcut 0 50 --yrange 0 1 $LepPt -A 'entry point' awayJetPt 'LepGood_awayJet_pt>50' -A 'entry point' eta 'abs(LepGood_eta)>1.2 && abs(LepGood_eta)<2.4' -L susy-sos/lepton-fr/frPuReweight.cc -W 'puw${TRIGGERName}_${YEAR}(PV_npvsGood)' -o $PBASE/QCD_${TRIGGERName}_Endcap.root  ${BG})"


