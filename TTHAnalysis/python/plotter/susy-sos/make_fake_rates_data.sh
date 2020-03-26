################################
#  use mcEfficiencies.py to make plots of the fake rate
################################
#T_SUSY="/data1/peruzzi/TREES_80X_011216_Spring16MVA_1lepFR --FDs /data1/peruzzi/frQCDVars_skimdata"

ANALYSIS=$1; if [[ "$1" == "" ]]; then exit 1; fi; shift;
case $ANALYSIS in
sos)
    YEAR=$1; shift; 
    case $YEAR in 2016) L=35.9;; 2017) L=41.5;; 2018) L=59.7;; esac
    #T="/eos/cms/store/user/ipapaver/FRNtuples_Data_MC/${YEAR}"; T0=$T 
    T="/eos/cms/store/user/ipapaver/FRNtuples_${YEAR}"; T0=$T
    echo "echo 'Will read trees from $T'"
    CUTFILE="susy-sos/lepton-fr/qcd1l.txt"; ;;
susy*) echo "NOT UP TO DATE"; exit 1;;
*) echo "You did not specify the analysis"; exit 1;;
esac;
BCORE=" --s2v --tree NanoAOD susy-sos/lepton-fr/mca-qcd1l-${YEAR}.txt ${CUTFILE} -P $T -l $L --AP "
BCORE="${BCORE}  --Fs /eos/cms/store/user/ipapaver/FRNtuples_${YEAR}/NewFO_FRiendTreesObjTaggers_${YEAR}"
echo "${BCORE}"
if [[ "$YEAR" == "2017" ]]; then
    BCORE="${BCORE} --mcc susy-sos/mcc_METFixEE2017.txt "; 
fi;

BG=" -j 8 "; if [[ "$1" == "-b" ]]; then BG=" & "; shift; fi

lepton=$1; if [[ "$1" == "" ]]; then exit 1; fi
lepdir=${lepton};
echo "lepton chossen is ${lepton}"
case $lepton in
mu) 
   BCORE="${BCORE} -E ^n_mu$ -E ^${lepton}$ -E ^${lepton}_den$ -E ^${lepton}_aj50$ --xf 'SingleEl.*,DoubleEG.*,EGamma.*'  "; NUM="muon_tight"; QCD=QCDMu; 
   conept="LepGood_pt" ;; 
el)
    BCORE="${BCORE} -E ^n_el$ -E ^${lepton}$ -E ^${lepton}_den$  --xf 'DoubleMu.*,SingleMu.*' ";  NUM="ele_tight"; QCD=QCDEl; 
    conept="LepGood_pt" ;;

esac;

echo "$BCORE"
trigger=$2; if [[ "$2" == "" ]]; then exit 1; fi
case $trigger in
Mu3_PFJet40)
    BCORE="${BCORE} -E ^mu3_pf40$ -E ^mu3_pf40_LepPt$"; 
    if [[ "$YEAR" == "2017" ]]; then BCORE="${BCORE} --xf '(Single|Double)Muon_Run2017B.*' "; fi # trigger was missing in that run period
    PUW=" -L susy-sos/lepton-fr/frPuReweight.cc -W 'puw${trigger}_${YEAR}(PV_npvsGood)' "
    ;;
Mu8)
    BCORE="${BCORE} -E ^mu8$ -E ^mu8_LepPt$ "; 
    PUW=" -L susy-sos/lepton-fr/frPuReweight.cc -W 'puw${trigger}_${YEAR}(PV_npvsGood)' "
    ;;
MuX_OR)
    #if [[ "$YEAR" == "2016" ]] ; then
    BCORE="${BCORE} -E ^muOR$ -E ^mu_aj50$";
    if [[ "$YEAR" == "2017" ]]; then BCORE="${BCORE} --xf '(Single|Double)Muon_Run2017B.*' "; fi # trigger was missing in that run period
    #CONEPTVAR="pt90_mvaPt0${MVAWP}_coarsecomb"
    PUW="-L susy-sos/lepton-fr/frPuReweight.cc -W 'puw${trigger}_${YEAR}(PV_npvsGood)' "
    ;;
#For low pt electron: mixture of PFJet triggers
PFJet)
    if [[ "$YEAR" = "2018" ]]; then
        BCORE="${BCORE} -E ^trig_el2018$ -E ^el_aj30$"; 
    else
        BCORE="${BCORE} -E ^trig_el2016_2017$ -E ^el_aj40$  "; 
    fi;
    PUW=" -L susy-sos/lepton-fr/frPuReweight.cc -W 'puwPFJet_${YEAR}(PV_npvsGood)' "
    ;;
*)
    BCORE="${BCORE} -A 'entry point' trigger 'HLT_${trigger}'  "; 
    PUW=" -L susy-sos/lepton-fr/frPuReweight.cc -W 'puw${trigger}_${YEAR}(PV_npvsGood)' "
    ;;
esac;


what=$3;
QCD_what=$4
PBASE="~/www/testEraRangeFRMaps_FullStatusReport/${YEAR}/qcd1l/$lepdir/HLT_$trigger/$what/"
echo $QCD_what
#flp: process to float
#--peg-process X Y make X scale as Y
EWKONE="-p ${QCD}_red,EWK,data"
EWKSPLIT="-p ${QCD}_red,WJets,DYJets,Top,data"
QCDEWKSPLIT="-p ${QCD}_[bclg]jets,WJets,DYJets,Top,data"
QCDSPLIT_EWKONE_NoTop="-p ${QCD}_red,${QCD}_[bclg]jets,EWK,data"
FITEWK=" $EWKSPLIT --flp WJets,DYJets,Top,${QCD}_red --peg-process DYJets WJets --peg-process Top WJets "
QCDNORM=" $QCDEWKSPLIT --sp WJets,DYJets,Top,${QCD}_.jets --scaleSigToData  "
QCDFITEWK=" $QCDEWKSPLIT --flp WJets,DYJets,${QCD}_.jets --peg-process DYJets WJets --peg-process ${QCD}_[clg]jets ${QCD}_bjets "
QCDFITQCD=" $QCDEWKSPLIT --flp WJets,DYJets,${QCD}_.jets --peg-process DYJets WJets --peg-process ${QCD}_[gl]jets WJets --peg-process ${QCD}_cjets ${QCD}_bjets "
QCDFITALL=" $QCDEWKSPLIT --flp WJets,DYJets,${QCD}_.jets --peg-process DYJets WJets --peg-process ${QCD}_gjets WJets --peg-process ${QCD}_cjets ${QCD}_bjets "

case $lepton in
    el) BARREL="00_15"; ENDCAP="15_25"; ETA="1.5";;
    mu) BARREL="00_12"; ENDCAP="12_24"; ETA="1.2";;
esac;

PLOTOPTS="--showRatio --maxRatioRange 0.0 1.99 --fixRatioRange  --legendColumns 2 --legendWidth 0.5"

case $what in
    test_pvdof)
        echo "python mcPlots.py -f -j 6 $BCORE susy-sos/lepton-fr/qcd1l_plots.txt -E pvdof --pdir $PBASE --sP lepsip3d $EWKONE"
        ;;
    test_Nopvdof)
        echo "python mcPlots.py -f -j 6 $BCORE susy-sos/lepton-fr/qcd1l_plots.txt --pdir $PBASE --sP lepsip3d $EWKONE"
        ;;
    nvtx)
        echo "python mcPlots.py -f -j 6 $BCORE susy-sos/lepton-fr/qcd1l_plots.txt --pdir $PBASE --sP nvtx $EWKONE " 
        echo "echo; echo; ";
        echo "python ../tools/vertexWeightFriend.py _puw${trigger}_${YEAR} $PBASE/qcd1l_plots.root ";
        echo "echo; echo ' ---- Now you should put the normalization and weight into frPuReweight.cc defining a puw${trigger}_${YEAR} ----- ' ";
        ;;
    nvtx-closure)
        echo "python mcPlots.py -f -j 6 $BCORE $PUW susy-sos/lepton-fr/qcd1l_plots.txt --pdir $PBASE --sP nvtx $EWKONE  --showRatio --maxRatioRange 0.9 1.1 " 
        ;;
    coneptw)
        echo "python mcPlots.py -f -j 6 $BCORE susy-sos/lepton-fr/make_fake_rates_xvars.txt --pdir $PBASE --sP ${CONEPTVAR}_nvtx $EWKONE " 
        echo "echo; echo; ";
        echo "python susy-sos/lepton-fr/frConePtWeights.py coneptw${trigger}_${YEAR} $PBASE/make_fake_rates_xvars.root ${CONEPTVAR}_nvtx  ";
        echo "echo; echo ' ---- Now you should put the normalization and weight into frPuReweight.cc defining a coneptw${trigger}_${YEAR} ----- ' ";
        ;;
    coneptw-closure)
        echo "python mcPlots.py -f -j 6 $BCORE $PUW susy-sos/lepton-fr/make_fake_rates_xvars.txt --pdir $PBASE --sP ${CONEPTVAR}_nvtx,$CONEPTVAR,nvtx $EWKONE " 
        ;;
    mc-yields)
        echo "python mcAnalysis.py -f -j 6 $BCORE $PUW ${EWKSPLIT} --sp 'QCD.*' --fom S/B --fom S/errSB -G " 
        ;;
    fit-*)
        echo "python mcPlots.py -f -j 6 $BCORE $PUW susy-sos/lepton-fr/qcd1l_plots.txt --pdir $PBASE -E $what $FITEWK --preFitData ${what/fit-/}  $PLOTOPTS " 
        ;;
    num-fit-*)
        echo "python mcPlots.py -f -j 6 $BCORE $PUW susy-sos/lepton-fr/qcd1l_plots.txt --pdir $PBASE -E $what $FITEWK --preFitData ${what/num-fit-/}  $PLOTOPTS -E num" 
        ;;
    num-mcshapes)
        echo "python mcPlots.py -f -j 6 $BCORE $PUW susy-sos/lepton-fr/qcd1l_plots.txt --pdir $PBASE -E $what ${EWKSPLIT/,data/} -E num_muon --plotmode=nostack" 
        ;;
    qcdflav-norm)
        echo "python mcPlots.py -f -j 6 $BCORE $PUW susy-sos/lepton-fr/qcd1l_plots.txt --pdir $PBASE -E $what $QCDNORM --showRatio $PLOTOPTS" 
        ;;
    qcdflav-fit)
        echo "python mcPlots.py -f -j 6 $BCORE $PUW susy-sos/lepton-fr/qcd1l_plots.txt --pdir $PBASE -E $what $QCDFITEWK --preFitData ${what/flav-fit/}  $PLOTOPTS " 
        ;;
    flav-fit*)
        echo "python mcPlots.py -f -j 6 $BCORE $PUW susy-sos/lepton-fr/qcd1l_plots.txt --pdir $PBASE -E $what $QCDFITQCD --preFitData ${what/flav-fit/}  $PLOTOPTS " 
        ;;
    flav3-fit*)
        echo "python mcPlots.py -f -j 6 $BCORE $PUW susy-sos/lepton-fr/qcd1l_plots.txt --pdir $PBASE -E $what $QCDFITALL --preFitData ${what/flav3-fit/}  $PLOTOPTS " 
        ;;
    fakerates-*)
        fitVar=${what/fakerates-/}
        XVAR="pt_fine"
        #XVAR="ptJI90_mvaPt0${MVAWP}_coarselongbin"
        LEGEND=" --legend=TL --fontsize 0.05 --legendWidth 0.4"
        RANGES=" --showRatio  --ratioRange 0.00 2.99 "
        STACK="python susy-sos/lepton-fr/stack_fake_rates_data.py "
        ISCOMB=false
        ISWIDE=false
        case $lepton in  
           el) 
               RANGES="$RANGES  --yrange 0 1 " ;
               case $trigger in
                  # Ele8)
                  #     XVAR="${XVAR}"
                  #     #/_coarselongbin/_coarseel8bin}"
                  #     RANGES="$RANGES --xcut 0 30 " ;;
                   PFJet)
                       XVAR="${XVAR}"
                       RANGES="$RANGES --xcut 0 30 " ;; 
                   EleX_Combined)
                       ISCOMB=true
                       ISWIDE=true
                       XVAR="${XVAR/_coarselongbin/_coarseelcomb}"
                       RANGES="${RANGES} --xcut 15 100  --xline 25 --xline 35 "; 
                       for E in ${BARREL} ${ENDCAP}; do
                           STACK=""
                           STACK="${STACK}  ${PBASE/EleX_Combined/Ele8}/fr_sub_eta_${E}.root:15-45"
                           STACK="${STACK}  ${PBASE/EleX_Combined/Ele17}/fr_sub_eta_${E}.root:25-100"
                           STACK="${STACK}  ${PBASE/EleX_Combined/Ele23}/fr_sub_eta_${E}.root:32-100"
                           echo "python susy-sos/lepton-fr/combine-fr-bins-prefit.py ${STACK} $PBASE/fr_sub_eta_${E}.root --oprefix ${NUM}_vs_${fitVar}_${XVAR}";
                       done;;
                   EleX_OR)
                       ISWIDE=true
                       XVAR="${CONEPTVAR}"
                       RANGES="${RANGES} --xcut 15 100  --xline 25 --xline 32 "; 
                 esac;; # ele trigger
           mu)
               RANGES="$RANGES  --yrange 0 1 " ;
               case $trigger in
                   Mu3_PFJet40)
                       RANGES="${RANGES} --xcut 0 30";;
                   Mu8)
                       XVAR="${XVAR}"
                       #/_coarselongbin/_coarsemu8bin}"
                       #ISWIDE=true
                       RANGES="${RANGES} --xcut 0 30";;
                   MuX_Combined)
                       ISCOMB=true
                       ISWIDE=true
                       XVAR="${XVAR}"
                       #/_coarselongbin/_coarsecomb}"
                       RANGES="${RANGES} --xcut 0 30"; 
                       for E in ${BARREL} ${ENDCAP}; do
                           STACK=""
                           STACK="${STACK}  ${PBASE/MuX_Combined/Mu3_PFJet40}/fr_sub_eta_${E}.root:3-8"
                           STACK="${STACK}  ${PBASE/MuX_Combined/Mu8}/fr_sub_eta_${E}.root:8-30"
                           #STACK="${STACK}  ${PBASE/MuX_Combined/Mu17}/fr_sub_eta_${E}.root:32-100"
                           #STACK="${STACK}  ${PBASE/MuX_Combined/Mu20}/fr_sub_eta_${E}.root:32-100"
                           #STACK="${STACK}  ${PBASE/MuX_Combined/Mu27}/fr_sub_eta_${E}.root:45-100"
                           echo "python susy-sos/lepton-fr/combine-fr-bins-prefit.py ${STACK} $PBASE/fr_sub_eta_${E}.root --oprefix ${NUM}_vs_${fitVar}_${XVAR}";
                       done;;
                   MuX_OR)
                       ISWIDE=true
                       XVAR="${XVAR}"
                       RANGES="${RANGES} --xcut 0 30";; 
                 esac;; # mu trigger
        esac; ## electron or muon

       case $QCD_what in
       QCD_One)
          QCD_sam="${QCD}_red  ";;
       QCD_SPLIT)
          QCD_sam="${QCD}_[bclg]jets";;
        esac;


        MCEFF="python susy-sos/dataFakeRate.py -f $BCORE $PUW $EWKONE --groupBy cut susy-sos/lepton-fr/qcd1l_num.txt susy-sos/lepton-fr/make_fake_rates_xvars.txt  "
        MCEFF="$MCEFF --sp ${QCD}_red "

        MCEFF="$MCEFF --sP ${NUM} --sP ${XVAR}  --sP $fitVar $fitVar  --ytitle 'Fake rate' "
        MCEFF="$MCEFF  " # ratio for fake rates
        MCEFF="$MCEFF --fixRatioRange --maxRatioRange 0.7 1.29 " # ratio for other plots

        MCEFF="$MCEFF $LEGEND $RANGES"
        if ! $ISCOMB; then

        echo " ( $MCEFF -o $PBASE/fr_sub_eta_${BARREL}.root --bare -A 'entry point' eta 'abs(LepGood_eta)<$ETA' $BG )"
        echo " ( $MCEFF -o $PBASE/fr_sub_eta_${ENDCAP}.root --bare -A 'entry point' eta 'abs(LepGood_eta)>$ETA' $BG )"
        fi;
        MCGO="$MCEFF --compare ${QCD}_red_prefit,data_sub_syst_prefit,data_sub_prefit --algo=globalFit "
        echo " ( $MCGO -i $PBASE/fr_sub_eta_${BARREL}.root -o $PBASE/fr_sub_eta_${BARREL}_globalFit.root --algo=globalFit --fcut 0 20 --subSyst 0.05 $BG )"
        echo " ( $MCGO -i $PBASE/fr_sub_eta_${ENDCAP}.root -o $PBASE/fr_sub_eta_${ENDCAP}_globalFit.root --algo=globalFit --fcut 0 20 --subSyst 0.05 $BG )"
        MCGO="$MCEFF --compare ${QCD}_red_prefit,data_prefit,total_prefit,data_sub_syst_prefit,data_sub_prefit --algo=globalFit "
        MCGO="${MCGO/--yrange 0 0.??/--yrange 0 0.5}"
        echo " ( $MCGO -i $PBASE/fr_sub_eta_${BARREL}.root -o $PBASE/fr_sub_eta_${BARREL}_globalFit_full.root --algo=globalFit --fcut 0 20 --subSyst 0.05 $BG )"
        echo " ( $MCGO -i $PBASE/fr_sub_eta_${ENDCAP}.root -o $PBASE/fr_sub_eta_${ENDCAP}_globalFit_full.root --algo=globalFit --fcut 0 20 --subSyst 0.05 $BG )"
        #MCGO="$MCEFF --compare ${QCD}_red_prefit,${QCD}_red --algo=fitND "
        #echo " ( $MCGO -i $PBASE/fr_sub_eta_${BARREL}.root -o $PBASE/fr_sub_eta_${BARREL}_full.root   $BG )"
        #echo " ( $MCGO -i $PBASE/fr_sub_eta_${ENDCAP}.root -o $PBASE/fr_sub_eta_${ENDCAP}_full.root   $BG )"
        case $lepton in el) CONSTRFSIG=0.05; CONSTRFBKG=0.10;; mu) CONSTRFSIG=0.075; CONSTRFBKG=0.03;; esac
        MCGO="$MCEFF --compare ${QCD}_red_prefit,data_fit --algo=fitSimND --shapeSystSignal=l:0.15,s:0.05,b:0.02 --shapeSystBackground=l:0.07,s:0.02,b:0.02 --kappaBkg 1.1 --constrain theta_bkg --sigmaFBkg $CONSTRFBKG --constrain fbkg "
        echo " ( $MCGO -i $PBASE/fr_sub_eta_${BARREL}.root -o $PBASE/fr_sub_eta_${BARREL}_fitSimND.root  $BG )"
        echo " ( $MCGO -i $PBASE/fr_sub_eta_${ENDCAP}.root -o $PBASE/fr_sub_eta_${ENDCAP}_fitSimND.root  $BG )"
        MCGO="$MCEFF --compare ${QCD}_red_prefit,data_fit --algo=fitSemiParND --shapeSystBackground=l:0.07,s:0.02,b:0.02 --kappaBkg 1.1 --constrain theta_bkg --sigmaFBkg $CONSTRFBKG --constrain fbkg "
        echo " ( $MCGO -i $PBASE/fr_sub_eta_${BARREL}.root -o $PBASE/fr_sub_eta_${BARREL}_fitSemiParND.root  $BG )"
        echo " ( $MCGO -i $PBASE/fr_sub_eta_${ENDCAP}.root -o $PBASE/fr_sub_eta_${ENDCAP}_fitSemiParND.root  $BG )"
        if $ISWIDE; then
            MCGO="$MCEFF --compare ${QCD}_red_prefit,data_fit --algo=fitGlobalSimND --shapeSystSignal=l:0.15,s:0.05,b:0.02 --shapeSystBackground=l:0.07,s:0.02,b:0.02 --regularize sf_sig 0.2 --regularize sf_bkg 0.1 --regularize fbkg $CONSTRFBKG  --regularize fsig $CONSTRFSIG"
            echo " ( $MCGO -i $PBASE/fr_sub_eta_${BARREL}.root -o $PBASE/fr_sub_eta_${BARREL}_fitGlobalSimND.root  $BG )"
            echo " ( $MCGO -i $PBASE/fr_sub_eta_${ENDCAP}.root -o $PBASE/fr_sub_eta_${ENDCAP}_fitGlobalSimND.root  $BG )"
            MCGO="$MCEFF --compare ${QCD}_red_prefit,data_fit --algo=fitGlobalSemiParND  --shapeSystBackground=l:0.07,s:0.02,b:0.02 --regularize sf_sig 0.2 --regularize sf_bkg 0.1  --regularize fsig $CONSTRFSIG --constrain fbkg --sigmaFBkg $CONSTRFBKG"
            echo " ( $MCGO -i $PBASE/fr_sub_eta_${BARREL}.root -o $PBASE/fr_sub_eta_${BARREL}_fitGlobalSemiParND.root  $BG )"
            echo " ( $MCGO -i $PBASE/fr_sub_eta_${ENDCAP}.root -o $PBASE/fr_sub_eta_${ENDCAP}_fitGlobalSemiParND.root  $BG )"
        fi;
        #if ! $ISCOMB; then
        MCGO="$MCEFF --compare ${QCD}_red_prefit,data_fqcd --algo=fQCD "
        echo " ( $MCGO -i $PBASE/fr_sub_eta_${BARREL}.root -o $PBASE/fr_sub_eta_${BARREL}_fQCD.root  $BG )"
        echo " ( $MCGO -i $PBASE/fr_sub_eta_${ENDCAP}.root -o $PBASE/fr_sub_eta_${ENDCAP}_fQCD.root  $BG )"
        MCGO="$MCEFF --compare ${QCD}_red_prefit,data_fqcd --algo=ifQCD "
        echo " ( $MCGO -i $PBASE/fr_sub_eta_${BARREL}.root -o $PBASE/fr_sub_eta_${BARREL}_ifQCD.root --subSyst 1.0 $BG )"
        echo " ( $MCGO -i $PBASE/fr_sub_eta_${ENDCAP}.root -o $PBASE/fr_sub_eta_${ENDCAP}_ifQCD.root --subSyst 1.0 $BG )"
        STACK="python susy-sos/lepton-fr/stack_fake_rates_data.py $RANGES $LEGEND --comb-mode=midpoint" # :_fit
        PATT="${NUM}_vs_${XVAR}_${fitVar}_%s"
        for E in ${BARREL} ${ENDCAP}; do
            echo "( $STACK -o $PBASE/fr_sub_eta_${E}_comp.root    $PBASE/fr_sub_eta_${E}_globalFit.root:$PATT:${QCD}_red_prefit,data_sub_syst_prefit  $PBASE/fr_sub_eta_${E}_ifQCD.root:$PATT:${QCD}_red_prefit,data_fqcd   $PBASE/fr_sub_eta_${E}_fitSimND.root:$PATT:data_fit   )";
            echo "( $STACK -o $PBASE/fr_sub_eta_${E}_comp1.root    $PBASE/fr_sub_eta_${E}_globalFit.root:$PATT:${QCD}_red_prefit,data_sub_syst_prefit  $PBASE/fr_sub_eta_${E}_ifQCD.root:$PATT:${QCD}_red_prefit,data_fqcd   $PBASE/fr_sub_eta_${E}_fitSemiParND.root:$PATT:data_fit   )";
            echo "( $STACK -o $PBASE/fr_sub_eta_${E}_compF.root    $PBASE/fr_sub_eta_${E}_globalFit.root:$PATT:data_sub_syst_prefit $PBASE/fr_sub_eta_${E}_fitSimND.root:$PATT:${QCD}_red_prefit,data_fit     $PBASE/fr_sub_eta_${E}_fitSemiParND.root:$PATT:data_fit --comp-style fitcomp  )";
            if $ISWIDE; then
                echo "( $STACK -o $PBASE/fr_sub_eta_${E}_compG.root    $PBASE/fr_sub_eta_${E}_globalFit.root:$PATT:data_sub_syst_prefit $PBASE/fr_sub_eta_${E}_fitGlobalSimND.root:$PATT:${QCD}_red_prefit,data_fit     $PBASE/fr_sub_eta_${E}_fitGlobalSemiParND.root:$PATT:data_fit --comp-style fitcomp  )";
            fi;
        done
        #fi
       ;;

esac;
