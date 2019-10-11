from PhysicsTools.NanoAODTools.postprocessing.framework.eventloop import Module
from PhysicsTools.NanoAODTools.postprocessing.framework.datamodel import Collection 

class lepJetBTagAdder( Module ):
    def __init__(self,jetBTagLabel,lepBTagLabel, lepCollection="LepGood", dummyValue=-99):
        self._jetBTagLabel = jetBTagLabel
        self._lepBTagLabel = lepBTagLabel
        self.lepCollection = lepCollection
        self._dummyValue = dummyValue
    def beginFile(self, inputFile, outputFile, inputTree, wrappedOutputTree):
        self.out = wrappedOutputTree
        self.out.branch(self.lepCollection+"_" + self._lepBTagLabel, "F", lenVar="n"+self.lepCollection)
    def analyze(self, event):
        leps = Collection(event, self.lepCollection)
        jets = Collection(event, 'Jet')
        nJets = len(jets)
        values = []
        for lep in leps:
            if lep.jetIdx >= 0 and lep.jetIdx < nJets:
                values.append(getattr(jets[lep.jetIdx], self._jetBTagLabel))
            else:
                values.append(self._dummyValue)
        self.out.fillBranch(self.lepCollection+"_" + self._lepBTagLabel, values)
        return True

lepJetBTagCSV = lambda : lepJetBTagAdder("btagCSVV2", "jetBTagCSV")
lepJetBTagDeepCSV = lambda : lepJetBTagAdder("btagDeepB", "jetBTagDeepCSV")
lepJetBTagDeepFlav = lambda : lepJetBTagAdder("btagDeepFlavB", "jetBTagDeepFlav")
lepJetBTagDeepFlavC = lambda : lepJetBTagAdder("btagDeepFlavC", "jetBTagDeepFlavC")

eleJetBTagDeepCSV = lambda : lepJetBTagAdder("btagDeepB", "jetBTagDeepCSV", "Electron")
muonJetBTagDeepCSV = lambda : lepJetBTagAdder("btagDeepB", "jetBTagDeepCSV", "Muon")

eleJetBTagCSV = lambda : lepJetBTagAdder("btagCSVV2", "jetBTagCSV", "Electron")
muonJetBTagCSV = lambda : lepJetBTagAdder("btagCSVV2", "jetBTagCSV", "Muon")
