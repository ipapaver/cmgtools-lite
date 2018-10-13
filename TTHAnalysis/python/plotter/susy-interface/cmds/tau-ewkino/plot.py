from tauUtils import command as command
from tauUtils import clean
from tauUtils import os
import string

"""
"""
        # Regions:
    # 
    # C:         3lC         SR-42            OSSF + 1tau
    # D:         3lD         SR-56            e mu tau
    # E:         3lE         SR-70            SS + 1 tau
    # F:         3lF         SR-80            A: OSSF, F: e/mu + 1tau
    # I:         3lI         SR-96            3l + 1tau

regions = {
    'C':      ['3lC', 'SR-42', 'OSSF + 1tau'              ], 
    'D':      ['3lD', 'SR-56', 'e mu tau'                 ],
    'E':      ['3lE', 'SR-70', 'SS + 1 tau'               ],
    'F':      ['3lF', 'SR-80', 'A: OSSF, F: e/mu + 1tau'  ],
    'I':      ['4lI', 'SR-96', '3l + 1tau'                ],
    'CRTAUH': ['CRTAUH', 'CRTAUH', 'Control regions tauh' ],
    }

"""
"""

import optparse
# Command line options
usage = 'usage: %prog [--newData]'
parser = optparse.OptionParser(usage)
parser.add_option('-i', '--input',          dest='inputDir',       help='input directory',        default='/pool/ciencias/HeppyTrees/RA7/estructura/trees_8011_July5_allscans/',           type='string')
parser.add_option('-o', '--output',         dest='outputDir',      help='output directory',       default='~/www/susyRA7/',           type='string')
parser.add_option('-a', '--action',         dest='action',         help='which action to perform', default='crtau', type='string')
parser.add_option('-s', '--subaction',      dest='subaction',      help='which subAction to perform', default='', type='string')
parser.add_option('-p', '--pretend',        dest='pretend',        help='only print commands out', action='store_true')

(opt, args) = parser.parse_args()

inputDir  = opt.inputDir
outputDir = opt.outputDir
action    = opt.action
subaction = opt.subaction
pretend   = opt.pretend
blind = '--flags "-X blinding"'

index="/nfs/fanae/user/vischia/www/index.php"

def runPlots(cuts, mca, out, plots, inputDir, outputDir, jei, lumi, mcc, mccother, trigdef, toplot, functions):
        clean(out)
        os.system('cp {index} {outputDir}'.format(index=index,outputDir=out))
        # --Fs {inputDir}/leptonJetReCleanerSusyEWK3L --Fs {inputDir}/leptonBuilderEWK 
        cmd = "python mcPlots.py {mca} {cuts} {plots} -P {inputDir} --Fs {inputDir}/leptonJetReCleanerSusyEWK2L --pdir {outputDir} -j {jei} -l {lumi} --s2v --tree treeProducerSusyMultilepton --mcc {mcc} --mcc {mccother} --mcc {trigdef} -f  --plotgroup fakes_appldata+=promptsub  --legendWidth 0.20 --legendFontSize 0.035 --showMCError -f {toplot} --showRatio --perBin --legendHeader \'EWK #tau_{{h}} CR\' --maxRatioRange 0.5 1.5 --fixRatioRange --ratioOffset 0.03  --load-macro {functions}".format(mca=mca,cuts=cuts,plots=plots,inputDir=inputDir,outputDir=out,jei=jei,lumi=lumi,mcc=mcc,mccother=mccother,trigdef=trigdef,toplot=toplot,functions=functions)
        command(cmd, pretend)
        os.system('cp {index} {outputDir}'.format(index=index,outputDir=out))

if(action=='generalplots'):
        cmd = 'print susy-interface/plotmaker.py 3l 3lA {inputDir} {outputDir} -l 12.9 --make data --plots br -o SR {blind} --pretend'.format(inputDir=inputDir,outputDir=outputDir,blind=blind)
        command(cmd, pretend)

elif(action=='tauopt'):
        mca='susy-ewkino/crtau/mca_taus.txt'
        for region in regions:
                if subaction and (region != subaction):
                        continue
                cmd = 'python susy-interface/plotmaker.py 3l {region} {inputDir} {outputDir} --mca {mca} -l 12.9 --make data --plots br -o {sr} {blind} -q batch '.format(region=regions[region][0],inputDir=inputDir,outputDir=outputDir,mca=mca,blind=blind,sr=regions[region][1])
                command(cmd,pretend)

elif(action=='crtauNotWorkingBecauseOfPeopleSBadCommitPolicies'):
        print 'Now plotting CRs for estimating tau fakes'
        mca='susy-ewkino/crtau/mca_taus.txt'
        #mca='susy-ewkino/3l/mca_ewkino.txt'
        cuts='susy-ewkino/crtau/cuts_qcd.txt'
        config='taustudies'
        config='taus'
        region='CRTAUH'
        batch=' -q batch '
        batch=''
        direct=' --pretend '
        direct=' '
        out=outputDir+'qcd/'
        cmd = 'python susy-interface/plotmaker.py {config} {region} {inputDir} {outputDir} --mca {mca} --cuts {cuts} -l 12.9 --make data -o {sr} {blind} {batch} {pretend}'.format(config=config,region=regions[region][0],inputDir=inputDir,outputDir=out,mca=mca,cuts=cuts,blind=blind,sr=regions[region][1],batch=batch,pretend=direct)
        print cmd
        command(cmd, pretend)
        
        cuts='susy-ewkino/crtau/cuts_ttbar.txt'
        out=outputDir+'ttbar/'
        cmd = 'python susy-interface/plotmaker.py {config} {region} {inputDir} {outputDir} --mca {mca} --cuts {cuts} -l 12.9 --make data  -o {sr} {blind} {batch} {pretend}'.format(config=config,region=regions[region][0],inputDir=inputDir,outputDir=out,mca=mca,cuts=cuts,blind=blind,sr=regions[region][1],batch=batch,pretend=direct)
        print cmd
        command(cmd, pretend)

        cuts='susy-ewkino/crtau/cuts_wjet.txt'
        out=outputDir+'wjet/'
        cmd = 'python susy-interface/plotmaker.py {config} {region} {inputDir} {outputDir} --mca {mca} --cuts {cuts} -l 12.9 --make data  -o {sr} {blind} {batch} {pretend}'.format(config=config,region=regions[region][0],inputDir=inputDir,outputDir=out,mca=mca,cuts=cuts,blind=blind,sr=regions[region][1],batch=batch,pretend=direct)
        print cmd
        command(cmd, pretend)

elif(action=='crtau'):
        print 'Now plotting CRs for estimating tau fakes'
        mca='susy-ewkino/crtau/mca_taus.txt'
        #mca='susy-ewkino/crwz/mca_crwz_forScan_12p9.txt'
        plots='susy-ewkino/crtau/plots_taus.txt'
        mcc='susy-ewkino/3l/mcc_ewkino.txt'
        #mcc='susy-ewkino/crwz/lepchoice-crwz-FO.txt'
        trigdef='susy-ewkino/mcc_triggerdefs.txt'
        functions='susy-ewkino/3l/functionsEWK.cc'
        toplot='--sP \'MET\''
        if(subaction!=''):
                toplot='--sP \'{toplot}\''.format(toplot=subaction)
        if(subaction=='all'):
                toplot=''
        config='taustudies'
        config='taus'
        region='CRTAUH'
        batch=' -q batch '
        batch=''
        direct=' --pretend '
        direct=' '
        jei='6'
        jei='60'
        lumi='1.0'

        cuts='susy-ewkino/crtau/cuts_qcd.txt'
        #cuts='susy-ewkino/crwz/cuts_crwz.txt'
        out=outputDir+'qcd/'
        clean(out)
        # When I will plot signal region, reimplement the {blind} part
        cmd = "python mcPlots.py {mca} {cuts} {plots} -P {inputDir} --Fs {inputDir}/leptonJetReCleanerSusyEWK2L --Fs {inputDir}/leptonBuilderEWK --pdir {outputDir} -j {jei} -l {lumi} --s2v --tree treeProducerSusyMultilepton --mcc {mcc} --mcc {trigdef} -f  --plotgroup fakes_appldata+=promptsub  --legendWidth 0.20 --legendFontSize 0.035 --showMCError -f {toplot} --showRatio --perBin --legendHeader \'EWK #tau_{{h}} CR\' --maxRatioRange 0.5 1.5 --fixRatioRange --ratioOffset 0.03  --load-macro {functions}".format(mca=mca,cuts=cuts,plots=plots,inputDir=inputDir,outputDir=out,jei=jei,lumi=lumi,mcc=mcc,trigdef=trigdef,toplot=toplot,functions=functions)
        #print cmd
        command(cmd, pretend)
        os.system('cp {index} {outputDir}'.format(index=index,outputDir=out))

        cuts='susy-ewkino/crtau/cuts_ttbar.txt'
        out=outputDir+'ttbar/'
        clean(out)
        # When I will plot signal region, reimplement the {blind} part
        cmd = "python mcPlots.py {mca} {cuts} {plots} -P {inputDir} --Fs {inputDir}/leptonJetReCleanerSusyEWK2L --Fs {inputDir}/leptonBuilderEWK --pdir {outputDir} -j {jei} -l {lumi} --s2v --tree treeProducerSusyMultilepton --mcc {mcc} --mcc {trigdef} -f  --plotgroup fakes_appldata+=promptsub  --legendWidth 0.20 --legendFontSize 0.035 --showMCError -f {toplot} --showRatio --perBin --legendHeader \'EWK #tau_{{h}} CR\' --maxRatioRange 0.5 1.5 --fixRatioRange --ratioOffset 0.03  --load-macro {functions}".format(mca=mca,cuts=cuts,plots=plots,inputDir=inputDir,outputDir=out,jei=jei,lumi=lumi,mcc=mcc,trigdef=trigdef,toplot=toplot,functions=functions)
        #print cmd
        command(cmd, pretend)
        #os.system('cp {index} {outputDir}'.format(index=index,outputDir=out))

        cuts='susy-ewkino/crtau/cuts_wjet.txt'
        out=outputDir+'wjet/'
        clean(out)
        # When I will plot signal region, reimplement the {blind} part
        cmd = "python mcPlots.py {mca} {cuts} {plots} -P {inputDir} --Fs {inputDir}/leptonJetReCleanerSusyEWK2L --Fs {inputDir}/leptonBuilderEWK --pdir {outputDir} -j {jei} -l {lumi} --s2v --tree treeProducerSusyMultilepton --mcc {mcc} --mcc {trigdef} -f  --plotgroup fakes_appldata+=promptsub  --legendWidth 0.20 --legendFontSize 0.035 --showMCError -f {toplot} --showRatio --perBin --legendHeader \'EWK #tau_{{h}} CR\' --maxRatioRange 0.5 1.5 --fixRatioRange --ratioOffset 0.03  --load-macro {functions}".format(mca=mca,cuts=cuts,plots=plots,inputDir=inputDir,outputDir=out,jei=jei,lumi=lumi,mcc=mcc,trigdef=trigdef,toplot=toplot,functions=functions)
        #print cmd
        command(cmd, pretend)
        os.system('cp {index} {outputDir}'.format(index=index,outputDir=out))

elif(action=='crconv'):
        print 'Now plotting CRs for estimating fakes from conversions'
        plots='susy-ewkino/crconv/plots_convs.txt'
        mcc='susy-ewkino/crconv/mcc_convs.txt'
        mccother='susy-ewkino/2lss/lepchoice-2lss-FO.txt'
        trigdef='susy-ewkino/mcc_triggerdefs.txt'
        functions='susy-ewkino/3l/functionsEWK.cc'
        toplot='--sP \'MET\''
        if(subaction!=''):
                toplot='--sP \'{toplot}\''.format(toplot=subaction)
        if(subaction=='all'):
                toplot=''
        batch=' -q batch '
        batch=''
        direct=' --pretend '
        direct=' '
        jei='6'
        jei='60'
        lumi='36.5'

        cuts='susy-ewkino/crconv/cuts_convs_3l.txt'
        mca='susy-ewkino/crconv/mca-3l-mc-conv.txt'
        out=outputDir+'3l_mc_conv/'
        runPlots(cuts, mca, out, plots, inputDir, outputDir, jei, lumi, mcc, mccother, trigdef, toplot, functions)

        cuts='susy-ewkino/crconv/cuts_convs_3l.txt'
        mca='susy-ewkino/crconv/mca-3l-mcdata-conv.txt'
        out=outputDir+'3l_mcdata_conv/'
        runPlots(cuts, mca, out, plots, inputDir, outputDir, jei, lumi, mcc, mccother, trigdef, toplot, functions)

        cuts='susy-ewkino/crconv/cuts_convs_2lgamma.txt'
        mca='susy-ewkino/crconv/mca-ss2l-mcdata-conv.txt'
        out=outputDir+'ss2lgamma_mcdata_conv/'
        runPlots(cuts, mca, out, plots, inputDir, outputDir, jei, lumi, mcc, mccother, trigdef, toplot, functions)

        cuts='susy-ewkino/crconv/cuts_convs_ss2l.txt'
        mca='susy-ewkino/crconv/mca-ss2l-mcdata-conv.txt'
        out=outputDir+'ss2l_mcdata_conv/'
        runPlots(cuts, mca, out, plots, inputDir, outputDir, jei, lumi, mcc, mccother, trigdef, toplot, functions)

print 'Everything is done now'
