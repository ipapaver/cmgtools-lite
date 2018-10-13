INPUTDIR="/nfs/fanae/user/vischia/TREES_80X_011216_Spring16MVA_skim_2lep_OR_1lep_2tau/"
OUTPUTDIR="/OBSOLETE"
WEBDIR="/nfs/fanae/user/vischia/www/taus/"

if [ "$1" == "ft" ]; then
    MODULE=""    
    PRETEND=" -q local --direct --pretend"
    PRETEND=" -q batch --direct "
    #PRETEND=" -q batch --direct --pretend"
    ONLY=" --accept WZZ "
    ONLY=" --accept WJetsToLNu " 
    ONLY=" "
    ONLY=" --accept DoubleEG_Run2016B_23Sep2016_v3_runs_273150_275376_part1 "
    if [ "$2" == "btag" ]; then
        MODULE="eventBTagWeight"
        #python susy-interface/friendmaker.py 3l 3lA ${INPUTDIR} ${INPUTDIR} --modules eventBTagWeight -q batch 
        # python susy-interface/friendmaker.py 3l 3lA ${INPUTDIR} ${OUTPUTDIR} --modules eventBTagWeight --accept WZZ -q batch --direct
        python susy-interface/friendmaker.py 3l 3lA ${INPUTDIR} ${OUTPUTDIR} --modules ${MODULE} ${ONLY} ${PRETEND}
    else
        if [ "$2" == "tauclean" ]; then
            MODULE="leptonJetReCleanerNoCleanTausSusyEWK3L"
        elif [ "$2" == "tauMini" ]; then
            MODULE="tauFakesBuilderEWKMini"
        elif [ "$2" == "tauRecl" ]; then
            MODULE="tauFakesBuilderEWKRecl"
        elif [ "$2" == "stdReCleaner2L" ]; then
            MODULE="leptonJetReCleanerSusyEWK2L"
        elif [ "$2" == "stdReCleaner3L" ]; then
            MODULE="leptonJetReCleanerSusyEWK3L"
        elif [ "$2" == "leptonBuilder" ]; then
            MODULE="leptonBuilderEWK"
        fi
        if [ "$MODULE" == "" ]; then
            print "No module specified"
            exit -1
        fi
        #3lA
        for EXCL in `ls ${INPUTDIR}`;
        do
            ONLY=" --accept ${EXCL} "
            python susy-interface/friendmaker.py taustudies CRTAUH ${INPUTDIR} ${OUTPUTDIR} --modules ${MODULE} ${ONLY} ${PRETEND}
        done
    fi

elif [ "$1" == "skim" ]; then

    # Improve flexibility through txt parsing, or acquire from "ls " as a default, and single comma separated sets if $3 is filled
    if [ "$2" == "tree" ]; then
        python /mnt_pool/fanae105/user/vischia/workarea/cmssw/susy/CMSSW_8_0_19/src/CMGTools/TTHAnalysis/python/plotter/skimTrees.py -j 64 -P /nfs/fanae/user/vischia/TREES_80X_011216_Spring16MVA_skim_2lep_OR_1lep_2tau/ --tree treeProducerSusyMultilepton  --Fs {P}/leptonJetReCleanerSusyEWK2L  --mcc susy-ewkino/mcc_triggerdefs.txt  --mcc susy-ewkino/2lss/lepchoice-2lss-FO.txt mca-skim.txt cuts-skim.txt /nfs/fanae/user/vischia/skimmedtrees_full
    elif [ "$2" == "ft" ]; then
        python skimFTrees.py /nfs/fanae/user/vischia/skimmedtrees_full /nfs/fanae/user/vischia/TREES_80X_011216_Spring16MVA_skim_2lep_OR_1lep_2tau/leptonBuilderEWK /nfs/fanae/user/vischia/skimmedtrees_full/leptonBuilderEWK  DoubleEG_Run2016F_23Sep2016_v1_runs_271036_284044_part1 DoubleEG_Run2016F_23Sep2016_v1_runs_271036_284044_part2 DoubleEG_Run2016F_23Sep2016_v1_runs_271036_284044_part3 DoubleEG_Run2016G_23Sep2016_v1_runs_271036_284044_part1 DoubleEG_Run2016G_23Sep2016_v1_runs_271036_284044_part2 DoubleEG_Run2016G_23Sep2016_v1_runs_271036_284044_part3 DoubleEG_Run2016G_23Sep2016_v1_runs_271036_284044_part4 DoubleEG_Run2016G_23Sep2016_v1_runs_271036_284044_part5 DoubleEG_Run2016G_23Sep2016_v1_runs_271036_284044_part6 DoubleMuon_Run2016F_23Sep2016_v1_runs_271036_284044_part1 DoubleMuon_Run2016F_23Sep2016_v1_runs_271036_284044_part2 DoubleMuon_Run2016F_23Sep2016_v1_runs_271036_284044_part3 DoubleMuon_Run2016F_23Sep2016_v1_runs_271036_284044_part4 DoubleMuon_Run2016F_23Sep2016_v1_runs_271036_284044_part5 DoubleMuon_Run2016G_23Sep2016_v1_runs_271036_284044_part1 DoubleMuon_Run2016G_23Sep2016_v1_runs_271036_284044_part2 DoubleMuon_Run2016G_23Sep2016_v1_runs_271036_284044_part3 DoubleMuon_Run2016G_23Sep2016_v1_runs_271036_284044_part4 DoubleMuon_Run2016G_23Sep2016_v1_runs_271036_284044_part5 DoubleMuon_Run2016G_23Sep2016_v1_runs_271036_284044_part6 DoubleMuon_Run2016G_23Sep2016_v1_runs_271036_284044_part7 DoubleMuon_Run2016G_23Sep2016_v1_runs_271036_284044_part8 DoubleMuon_Run2016G_23Sep2016_v1_runs_271036_284044_part9 MuonEG_Run2016F_23Sep2016_v1_runs_271036_284044 MuonEG_Run2016G_23Sep2016_v1_runs_271036_284044_part1 MuonEG_Run2016G_23Sep2016_v1_runs_271036_284044_part2 SingleElectron_Run2016F_23Sep2016_v1_runs_271036_284044 SingleElectron_Run2016G_23Sep2016_v1_runs_271036_284044 SingleMuon_Run2016F_23Sep2016_v1_runs_271036_284044 SingleMuon_Run2016G_23Sep2016_v1_runs_271036_284044_part1 SingleMuon_Run2016G_23Sep2016_v1_runs_271036_284044_part2
    fi
    
elif [ "$1" == "plot" ]; then
    
    ACTION=""
    SUBACTION=""
    # ACTION can be generalplots or tauopt or crtau
    
    if [ "$2" == "" ]; then
        echo "ACTION is empty. It can be generalplots or tauopt or crtau or crconv"
        exit -1
    else
        ACTION=" -a ${2}"
        if [ "$3" != "" ]; then
            SUBACTION=" -s ${3} "
        fi
    fi
    
    if [ "$ACTION" == " -a crconv" ]; then
        WEBDIR="/nfs/fanae/user/vischia/www/conversions/"
    fi
    PRETEND=" --pretend  "
    PRETEND=""
    echo " ========================== WARNING ==========================="
    echo " Process WWTo2L2Nu is missing from the current trees production"
    echo " When present, must re-enable it in the mca"
    echo " =============================================================="
    python susy-interface/cmds/tau-ewkino/plot.py -i ${INPUTDIR} -o ${WEBDIR} ${ACTION} ${SUBACTION} ${PRETEND}
    echo " ========================== WARNING ==========================="
    echo " Process WWTo2L2Nu is missing from the current trees production"
    echo " When present, must re-enable it in the mca"
    echo " =============================================================="

fi
exit 0