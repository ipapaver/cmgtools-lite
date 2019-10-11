#!/usr/bin/env python
import sys
import os
import ROOT
import argparse

def canvasToImage(canvas):
    img = ROOT.TImage.Create()
    img.FromPad(canvas)
    img.WriteImage(args.pdir+"overlayPlots/"+sys.argv[1]+"/"+str( canvas.GetName() )+".png")

def histoCosmetics(histo,year):
    histo.SetLineColor(color[year]); histo.SetLineWidth(2)
    histo.SetMarkerColor(color[year]); histo.SetMarkerStyle(20); histo.SetMarkerSize(1.2)
    histo.GetXaxis().SetTitleSize(0.05); histo.GetXaxis().SetTitleOffset(0.95)
    histo.GetYaxis().SetTitleSize(0.05); histo.GetYaxis().SetTitleOffset(0.85) 
    histo.SetMinimum(0.0); histo.SetMaximum(1.0);
    

helpText = "python overlayPlots.py [particle] [options]\n \
[particle] can be 'muon' or 'ele'\n \
[options] are described below (no option means all possible combinations):"

parser = argparse.ArgumentParser(helpText)

parser.add_argument("particle")
parser.add_argument("--ID", dest="ID", default=[], nargs="*", help="Choose ID(s)")
parser.add_argument("--kinRes", dest="kinRes", default=[], nargs="*", help="Choose kinematical restriction(s): '', '_PtRes', '_Barrel', '_Endcap'")
parser.add_argument("--variable", dest="variable", default=[], nargs="*", help="Choose variable(s): 'Pt', 'Eta'")
parser.add_argument("--year", dest="year", default=[], nargs="*", help="Choose year(s)")
parser.add_argument("--pdir", dest="pdir", default="susy-sos-v2-clean/leptonIdEffResults/", help="pdir for the mcPlots.py (default=%default)")
parser.add_argument("--moretext", dest="moretext", default="", help="Suffix for the folder name")
args = parser.parse_args()

IDmuonArr = ["Soft","FO","TightSOS","FOnoBtag"]
IDeleArr = ["VLFO","TightWP80","TightWP90","TightWPL","FO","TightSOS","FOnoBtag"]
if sys.argv[1] == "muon":
    for ID in args.ID:
        if ID not in IDmuonArr: raise RuntimeError( "ID '{}' doesn't exist!".format(ID) )
    IDArr = IDmuonArr if len(args.ID) == 0 else args.ID
elif sys.argv[1] == "ele":
    for ID in args.ID:
        if ID not in IDeleArr: raise RuntimeError( "ID '{}' doesn't exist!".format(ID) )
    IDArr = IDeleArr if len(args.ID) == 0 else args.ID
else: raise RuntimeError("The first argument should be either 'muon' or 'ele'!")

kinResArr = ["","_PtRes","_Barrel","_Endcap"] if len(args.kinRes) == 0 else args.kinRes
variableArr = ["Pt","Eta"] if len(args.variable) == 0 else args.variable
yearArr = ["2016","2017","2018"] if len(args.year) == 0 else args.year
color = {"2016" : 2, "2017" : 4, "2018" : 1}

ROOT.gROOT.SetBatch(1); ROOT.gStyle.SetOptStat(0); ROOT.gStyle.SetOptTitle(0)
inFiles = {}
outFile = ROOT.TFile(args.pdir+"overlayPlots/"+sys.argv[1]+"/"+sys.argv[1]+"OverlayPlots.root","recreate")

for ID,kinRes,var in [(ID,kinRes,var) for ID in IDArr for kinRes in kinResArr for var in variableArr]:
    if var == "Eta" and kinRes in ["_Barrel","_Endcap"]: continue
    if ID == "FO_noBtag" and kinRes != "" and var != "_Pt": continue
    print ID, kinRes, var
    name = "{particle}{variable}Eff_{ID}{kinRes}".format(particle=sys.argv[1],variable=var,ID=ID,kinRes=kinRes)
    canvas = ROOT.TCanvas(name,name)
    for year in yearArr:
        fileKey = "{kinRes}_{year}".format(kinRes=kinRes,year=year)
        if not inFiles.has_key(fileKey):
            inFiles[fileKey] = ROOT.TFile( args.pdir+"{year}/{particle}/{particle}Eff{kinRes}.root".format(year=year,particle=sys.argv[1],kinRes=kinRes),"read" )

        histo = inFiles[fileKey].Get(name+"_%s_prompt_dy"%year[-2:])
        histo.SetName(year); histo.SetTitle(year); histo.Draw("same")
        histoCosmetics(histo,year)

    canvas.BuildLegend(0.5,0.15,0.75,0.40)
    outFile.cd(); canvas.Write(); canvasToImage(canvas)
