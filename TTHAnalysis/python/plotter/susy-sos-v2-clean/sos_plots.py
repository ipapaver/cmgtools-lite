#!/usr/bin/env python
import sys
import re
import os

ODIR=sys.argv[1]
YEAR=sys.argv[2]
lumis = {
'2016': '35.9', # '33.2' for low MET bin, replaced below
'2017': '41.53', # '36.74' for low MET bin, replaced below
'2018': '59.74',
}
LUMI= " -l %s "%(lumis[YEAR])


submit = '{command}' 
dowhat = "plots" 
#dowhat = "dumps" 
#dowhat = "yields" 
#dowhat = "ntuple"

P0="/eos/cms/store/cmst3/group/tthlep/peruzzi/NanoTrees_SOS_230819_v5/"
#P0="/eos/cms/store/cmst3/group/tthlep/peruzzi/NanoTrees_SOS_170619_v5pre/"
nCores = 8
TREESALL = " --Fs {P}/recleaner -P "+P0+"%s "%(YEAR,)

def base(selection):
    CORE=TREESALL
    CORE+=" -f -j %d --split-factor=-1 --year %s --s2v -L susy-sos-v2-clean/functionsSOS.cc -L susy-sos-v2-clean/functionsSF.cc --tree NanoAOD --mcc susy-sos-v2-clean/mcc_sos.txt --mcc susy-sos-v2-clean/mcc_triggerdefs.txt "%(nCores,YEAR) # --neg"
    if YEAR == "2017": CORE += " --mcc susy-sos-v2-clean/mcc_METFixEE2017.txt "
    RATIO= " --maxRatioRange 0.0  1.99 --ratioYNDiv 505 "
    RATIO2=" --showRatio --attachRatioPanel --fixRatioRange "
    LEGEND=" --legendColumns 2 --legendWidth 0.25 "
    LEGEND2=" --legendFontSize 0.042 "
    SPAM=" --noCms --topSpamSize 1.1 --lspam '#scale[1.1]{#bf{CMS}} #scale[0.9]{#it{Preliminary}}' "
    if dowhat == "plots": CORE+=LUMI+RATIO+RATIO2+LEGEND+LEGEND2+SPAM+" --showMCError "

    if selection=='2los':
        GO="%s susy-sos-v2-clean/mca-2los-%s.txt susy-sos-v2-clean/2los_cuts.txt "%(CORE,YEAR)

        if YEAR == "2016": GO="%s -W '1.0*1.0'"%GO # to be fixed 
        if YEAR == "2017": GO="%s -W 'puWeight*getLepSF_17(LepGood1_pt, LepGood1_eta, LepGood1_pdgId)*getLepSF_17(LepGood2_pt, LepGood2_eta, LepGood2_pdgId)'"%GO 

        if dowhat == "plots": GO=GO.replace(LEGEND, " --legendColumns 3 --legendWidth 0.52 ")
        if dowhat == "plots": GO=GO.replace(RATIO,  " --maxRatioRange 0.6  1.99 --ratioYNDiv 210 ")
        GO += " --binname 2los "

    elif selection=='3l':
        GO="%s susy-sos-v2-clean/mca-3l-%s.txt susy-sos-v2-clean/3l_cuts.txt "%(CORE,YEAR)

        #GO="%s -W 'puWeight*btagSF_shape*leptonSF_3l*triggerSF_3l'"%GO # to be fixed

        if dowhat == "plots": GO=GO.replace(LEGEND, " --legendColumns 3 --legendWidth 0.42 ")
        GO += " --binname 3l "

    else:
        raise RuntimeError('Unknown selection')

    if dowhat in ["plots","ntuple"]: GO+=" susy-sos-v2-clean/2los_3l_plots.txt "

    return GO

def promptsub(x):
    procs = [ '' ]
    if dowhat == "cards": procs += ['_FRe_norm_Up','_FRe_norm_Dn','_FRe_pt_Up','_FRe_pt_Dn','_FRe_be_Up','_FRe_be_Dn','_FRm_norm_Up','_FRm_norm_Dn','_FRm_pt_Up','_FRm_pt_Dn','_FRm_be_Up','_FRm_be_Dn']
    return x + ' '.join(["--plotgroup data_fakes%s+='.*_promptsub%s'"%(x,x) for x in procs])+" --neglist '.*_promptsub.*' "

def procs(GO,mylist):
    return GO+' '+" ".join([ '-p %s'%l for l in mylist ])

def sigprocs(GO,mylist):
    return procs(GO,mylist)+' --showIndivSigs --noStackSig'

def runIt(GO,name,plots=[],noplots=[]):
    if dowhat == "plots":  
        if not ('forcePlotChoice' in sys.argv[4:]): print submit.format(command=' '.join(['python mcPlots.py',"--pdir %s/%s/%s"%(ODIR,YEAR,name),GO,' '.join(['--sP %r'%p for p in plots]),' '.join(['--xP %r'%p for p in noplots]),' '.join(sys.argv[4:])]))
        else: print 'python mcPlots.py',"--pdir %s/%s/%s"%(ODIR,YEAR,name),GO,' '.join([x for x in sys.argv[4:] if x!='forcePlotChoice'])
    elif dowhat == "yields": print 'echo %s; python mcAnalysis.py'%name,GO,' '.join(sys.argv[4:])
    elif dowhat == "dumps":  print 'echo %s; python mcDump.py'%name,GO,' '.join(sys.argv[4:])
    elif dowhat == "ntuple": print 'echo %s; python mcNtuple.py'%name,GO,' '.join(sys.argv[4:])

def add(GO,opt):
    return '%s %s'%(GO,opt)

def setwide(x):
    x2 = add(x,'--wide')
    x2 = x2.replace('--legendWidth 0.35','--legendWidth 0.20')
    return x2

def binChoice(x,torun):
    metBin = ''
    if '_low' in torun:
        metBin = 'met125'
    if '_med' in torun:
        metBin = 'met200'
    if '_high' in torun:
        metBin = 'met250'
    x2 = add(x,'-E ^'+metBin+' -E ^'+metBin+'_trig ')
    return x2

allow_unblinding = False


if __name__ == '__main__':

    torun = sys.argv[3]

    if (not allow_unblinding) and '_data' in torun and (not any([re.match(x.strip()+'$',torun) for x in ['.*_appl.*','cr_.*','3l.*_Zpeak.*']])): raise RuntimeError, 'You are trying to unblind!'


    if '2los_' in torun:
        x = base('2los')
        if '_low' or '_med' or '_high' in torun: x = binChoice(x,torun)
    
        if 'sr' in torun:
            if '_col' in torun:
                x = add(x,"-X ^mT -X ^SF ")
                if '_med' or '_high' in torun: x = add(x,"-X ^pt5sublep ")

        if 'appl' in torun:
            if '_col' in torun:
                x = add(x,"-X ^mT -X ^SF ")
                if '_med' or '_high' in torun: x = add(x,"-X ^pt5sublep ")
            x = add(x,"-X ^twoTight ")
            x = add(x,"-E ^oneNotTight ")

        if 'cr_dy' in torun:
            if '_med' in torun: x = x.replace('-E ^met200 ','-E ^met200_CR ')
            x = add(x,"-X ^ledlepPt -X ^twoTight ")
            x = add(x,"-I ^mtautau ")
            x = add(x,"-E ^CRDYlepId -E ^CRDYledlepPtIp ")

        if 'cr_tt' in torun:
            if '_med' in torun: x = add(x,'-E ^met200_CR -X ^pt5sublep ')
            x = add(x,"-X ^ledlepPt -X ^twoTight -X ^bveto -X ^mT ")
            x = add(x,"-E ^CRTTlepId -E ^CRTTledlepPt -E ^btag ")

        if 'cr_ww' in torun:
            if '_med' in torun: x = add(x,'-E ^met200_CR -X ^pt5sublep ')
            x = add(x,"-X ^ledlepPt -X ^twoTight -X ^mT ")
            x = add(x,"-E ^CRWWlepId -E ^CRWWleplepPt -E ^CRWWmT ")

        if 'cr_ss' in torun:
            if '_med' in torun: x = add(x,'-E ^met200_CR -X ^pt5sublep ')
            x = add(x,"-X ^mT ")
            x = add(x,"-I ^OS ")

        if '_data' not in torun: x = add(x,'--xp data ')
        if '_unc' in torun: x = add(x,"--unc susy-sos-v2-clean/systsUnc.txt")
        if '_norm' in torun: x = add(x,"--sp '.*' --scaleSigToData ")


    elif '3l_' in torun:
        x = base('3l')
        if '_low' or '_med' or '_high' in torun: x = binChoice(x,torun)
    
        if 'appl' in torun:
            x = add(x,"-X ^threeTight ")
            x = add(x,"-E ^oneNotTight ")

        if 'cr_wz' in torun:
            x = add(x,"-X ^minMll -X ^ZvetoTrigger -X ^ledlepPt -X ^pt5sublep ")
            x = x.replace('-E ^met200 ','-E ^met200_CR ')
            if '_min' or '_low' in torun:
                x = add(x,"-E ^CRWZPtLep_MuMu ")
                if '_min' in torun: x = x.replace(x,'-E ^ -E ^_trig','-E ^met75_CR -E met75_trig_CR ')
                if '_low' in torun: x = x.replace(x,'-E ^met125_trig','-E met125_trig_CR ')
            if '_med' in torun: x = add(x,"-E ^CRWZPtLep_HighMET ")

        if '_data' not in torun: x = add(x,'--xp data ')
        if '_unc' in torun: x = add(x,"--unc ttH-multilepton/systsUnc.txt")
        if '_norm' in torun: x = add(x,"--sp '.*' --scaleSigToData ")


    else: raise RuntimeError("You must include either '2los' or '3l' in the command!") 


    if '_low' in torun and YEAR=="2016":
        x = x.replace(LUMI," -l 33.2 ")
    if '_low' in torun and YEAR=="2017":
        x = x.replace(LUMI," -l 36.74 ")
        x = add(x,"-E ^xpRun2017B ")

    runIt(x,'%s'%torun)

######################################################################################
# Useful options for plotting, to be used when needed
#
#        if '_appl' in torun: x = add(x,'-I ^TT ')
#        if '_1fo' in torun:
#            x = add(x,"-A alwaystrue 1FO 'LepGood1_isLepTight+LepGood2_isLepTight==1'")
#        if '_2fo' in torun: x = add(x,"-A alwaystrue 2FO 'LepGood1_isLepTight+LepGood2_isLepTight==0'")
#        if '_relax' in torun: x = add(x,'-X ^TT ')
#        if '_extr' in torun:
#            x = x.replace('mca-2lss-mc.txt','mca-2lss-mc-sigextr.txt').replace('--showRatio --maxRatioRange 0 2','--showRatio --maxRatioRange 0 1 --ratioYLabel "S/B"')
#        if '_data' not in torun: x = add(x,'--xp data ')
#        if '_table' in torun:
#            x = x.replace('mca-2lss-mc.txt','mca-2lss-mc-table.txt')
#        if '_frdata' in torun: # Why?
#            x = promptsub(x)
#            if '_blinddata' in torun:
#                x = x.replace('mca-2lss-mc.txt','mca-2lss-mcdata.txt')
#                x = add(x,'--xp data ')
#            elif not '_data' in torun: raise RuntimeError
#            x = x.replace('mca-2lss-mcdata.txt','mca-2lss-mcdata-frdata.txt')
#            if '_table' in torun:
#                x = x.replace('mca-2lss-mcdata-frdata.txt','mca-2lss-mcdata-frdata-table.txt')
###
#            if '_leadmupt25' in torun: x = add(x,"-A 'entry point' leadmupt25 'abs(LepGood1_pdgId)==13 && LepGood1_pt>25' ")
#            if '_highMetNoBCut' in torun: x = add(x,"-A 'entry point' highMET 'met_pt>60'")
#            else: x = add(x,"-E ^1B ")
