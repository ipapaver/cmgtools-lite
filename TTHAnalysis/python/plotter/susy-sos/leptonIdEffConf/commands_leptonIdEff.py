#!/usr/bin/env python
import sys
import os

helpText = "python commands_leptonIdEff.py [particle] [year] [options]\n \
[particle] can be 'muon' or 'ele'\n \
[year] can be '2016', '2017' or '2018'\n \
[options] are described below (choose one or none):"

from optparse import OptionParser
parser = OptionParser(helpText)
parser.add_option("--ptRes", dest="ptRes", default=False, action="store_true", help="Plot eta efficiencies with pt in the range [3.5,30.0] GeV for muons and [5.0,30.0] GeV for electrons")
parser.add_option("--barrel", dest="barrel", default=False, action="store_true", help="Plot pt efficiencies with |eta| in the range [0.0,1.2] for muons and [0.0,1.47] GeV for electrons")
parser.add_option("--endcap", dest="endcap", default=False, action="store_true", help="Plot pt efficiencies with |eta| in the range [1.2,2.4] for muons and [1.47,2.5] GeV for electrons")
parser.add_option("--pdir", dest="pdir", default="susy-sos-v2-clean/leptonIdEffResults", help="pdir for the mcPlots.py (default=%default)")
parser.add_option("--moretext", dest="moretext", default="", help="Suffix for the folder name")
options, args = parser.parse_args()

if sys.argv[1] not in ["muon","ele"] :
    raise RuntimeError("The first argument should be either 'muon' or 'ele'!")
if sys.argv[2] not in ["2016","2017","2018"] :
    raise RuntimeError("The second argument should be the year, i.e. '2016', 2017' or '2018'!")

directory = options.pdir+"/"+sys.argv[2]+"/"+sys.argv[1]+options.moretext

command = "python mcPlots.py --pdir "+directory+" --Fs {P}/eleFlags_withBtag --Fs {P}/lepBTag -P /eos/cms/store/cmst3/user/vtavolar/susySOS/DYJets/"+sys.argv[2]+"/DYJetsToLL_M10to50_LO/ -f -j 8 --split-factor=-1 --year "+sys.argv[2]+" --s2v --tree NanoAOD susy-sos-v2-clean/leptonIdEffConf/mca_leptonIdEff.txt susy-sos-v2-clean/leptonIdEffConf/cuts_leptonIdEff.txt susy-sos-v2-clean/leptonIdEffConf/plots_leptonIdEff.txt -E ^"+sys.argv[1]+"Den"

if options.ptRes==True :
    command = command + " -E ^"+sys.argv[1]+"Pt --sP ^"+sys.argv[1]+".*\(?\<\=\(PtRes\)\)$ --out "+directory+"/"+sys.argv[1]+"Eff_PtRes.root"
elif options.barrel==True :
    command = command + " -E ^"+sys.argv[1]+"Barrel --sP ^"+sys.argv[1]+".*\(?\<\=\(Barrel\)\)$ --out "+directory+"/"+sys.argv[1]+"Eff_Barrel.root"
elif options.endcap==True :
    command = command + " -E ^"+sys.argv[1]+"Endcap --sP ^"+sys.argv[1]+".*\(?\<\=\(Endcap\)\)$ --out "+directory+"/"+sys.argv[1]+"Eff_Endcap.root"
else :
    command = command + " --sP ^"+sys.argv[1]+".*\(?\<\![\(Res\)\(Barrel\)\(Endcap\)]\)$ --out "+directory+"/"+sys.argv[1]+"Eff.root"

if sys.argv[2]=="2017" :
    command = command + " --mcc susy-sos-v2-clean/leptonIdEffConf/mcc_leptonIdEff_2017.txt"

print command
