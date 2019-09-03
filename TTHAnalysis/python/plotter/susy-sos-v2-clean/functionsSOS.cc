// we need headers
#include <cmath>
#include <algorithm>
#include "Math/GenVector/LorentzVector.h"
#include "Math/GenVector/PtEtaPhiM4D.h"
#include "Math/GenVector/PxPyPzM4D.h"
#include "TString.h"
#include "TRandom3.h"

// we need to declare the functions we use from functions.cc
float pt_2(float,float,float,float) ;
float pt_3(float,float,float,float,float,float) ;
float pt_4(float, float, float, float , float, float , float, float);

// and we need an empty function
void functionsSOS() {}
// and we can check that everything compiles fine with
// $ root.exe -b -l -q functions.cc+ susy-sos/functionsSOS.cc+

float mass_tautau( float Met_Pt, float Met_Phi,  float l1_Pt, float l1_Eta, float l1_Phi, float l2_Pt, float l2_Eta, float l2_Phi ) {
  typedef ROOT::Math::LorentzVector<ROOT::Math::PtEtaPhiM4D<double> > PtEtaPhiMVector;
  typedef ROOT::Math::LorentzVector<ROOT::Math::PxPyPzM4D<double>   > PxPyPzMVector;
  PtEtaPhiMVector Met( Met_Pt, 0.     , Met_Phi , 0.   );
  PtEtaPhiMVector L1(  l1_Pt , l1_Eta , l1_Phi  , 0.106 );
  PtEtaPhiMVector L2(  l2_Pt , l2_Eta , l2_Phi  , 0.106 );   // 0.106 mu mass                                                                                                                                                 
  float A00,A01,A10,A11,  C0,C1,  X0,X1,  inv_det;     // Define A:2x2 matrix, C,X 2x1 vectors & det[A]^-1                                                                                                                    
  inv_det = 1./( L1.Px()*L2.Py() - L2.Px()*L1.Py() );
  A00 = inv_det*L2.Py();     A01 =-inv_det*L2.Px();
  A10 =-inv_det*L1.Py();     A11 = inv_det*L1.Px();
  C0  = (Met+L1+L2).Px();    C1  = (Met+L1+L2).Py();
  X0  = A00*C0 + A01*C1;     X1  = A10*C0 + A11*C1;
  PxPyPzMVector T1( L1.Px()*X0 , L1.Py()*X0 , L1.Pz()*X0 , 1.777 );    // 1.777 tau mass                                                                                                                                      
  PxPyPzMVector T2( L2.Px()*X1 , L2.Py()*X1 , L2.Pz()*X1 , 1.777 );
  if(X0>0.&&X1>0.)return  (T1+T2).M();
  else            return -(T1+T2).M();
}



int SR_bins_EWKino(float Mll){
  if     (4.<Mll && Mll<9.5) return 1;
  else if(10.5<Mll && Mll<=20.) return 2;
  else if(20.<Mll && Mll<=30.) return 3;
  else if(30.<Mll) return 4;
  else return -99;
}

int SR_bins_stop(float ptlep1){
  if     (ptlep1 <=12.) return 1;
  else if(ptlep1 >12. && ptlep1 <=20.) return 2;
  else if(ptlep1 >20.) return 3; 
  else return -99;
}


float metmm_pt(int pdg1, float pt1, float phi1, int pdg2, float pt2, float phi2, float metpt, float metphi) {
  if (std::abs(pdg1)==13 && std::abs(pdg2)==13) return pt_3(pt1,phi1,pt2,phi2,metpt,metphi);
  else if (std::abs(pdg1)==13 && !(std::abs(pdg2)==13)) return pt_2(pt1,phi1,metpt,metphi);
  else if (!(std::abs(pdg1)==13) && std::abs(pdg2)==13) return pt_2(pt2,phi2,metpt,metphi);
  else if (!(std::abs(pdg1)==13) && !(std::abs(pdg2)==13)) return metpt;
  else {
    std::cout << "Error in metmm_pt" << std::endl;
    return -99;
  }
}


float lepton_Id_selection(int pdg1, int pdg2, int pdg3){
  if (std::abs(pdg1)==13 && std::abs(pdg2)==13 && std::abs(pdg3) ==13) return 123;
  else if (std::abs(pdg1)==13 && std::abs(pdg2)==13 && !(std::abs(pdg3)==13))return 12; 
  else if (std::abs(pdg1)==13 && !(std::abs(pdg2)==13) && std::abs(pdg3) == 13)return 13; 
  else if (!(std::abs(pdg1)==13) && std::abs(pdg2)==13 && std::abs(pdg3)==13)return 23;
  else if (std::abs(pdg1)==13 && !(std::abs(pdg2)==13) && !(std::abs(pdg3)==13))return 1;
  else if (!(std::abs(pdg1)==13) && std::abs(pdg2)==13 && !(std::abs(pdg3)==13)) return 2;  
  else if (!(std::abs(pdg1)==13) && !(std::abs(pdg2)==13) && (std::abs(pdg3)==13))return 3;
  else if (!(std::abs(pdg1)==13) && !(std::abs(pdg2)==13) && !(std::abs(pdg3)==13)) return 4;
  else {
    std::cout << "Error in lepton_Id_selection" << std::endl;
    return -99;
  }
  }



float metmmm_pt( float pt1, float phi1, float pt2, float phi2, float pt3, float phi3, float metpt, float metphi, int lepton_code) {
  if (lepton_code == 123)  return pt_4(pt1, phi1, pt2, phi2, pt3, phi3, metpt, metphi);
  else if (lepton_code == 12) return pt_3(pt1,phi1,pt2,phi2,metpt,metphi);
  else if (lepton_code == 13) return pt_3(pt1, phi1, pt3, phi3, metpt, metphi);
  else if (lepton_code == 23) return pt_3(pt2, phi2, pt3, phi3, metpt, metphi);
  else if (lepton_code == 1) return pt_2(pt1, phi1, metpt, metphi);
  else if (lepton_code == 2) return pt_2(pt2,phi2,metpt,metphi);  
  else if (lepton_code == 3) return pt_2(pt3,phi3, metpt, metphi);
  else if (lepton_code == 4) return metpt;
  else {
    std::cout << "Error in metmmm_pt" << std::endl;
    return -99;
  }
}


float eleWPVVL(float pt, float etaSc, float mva){
  if (pt<=10 && ((std::abs(etaSc)<0.8 && mva>-0.265) || (std::abs(etaSc)>=0.8 && std::abs(etaSc)<1.479 && mva > -0.556) || (std::abs(etaSc)>=1.479 && mva>-0.6))) return 1;
  else if (pt>10 && ((std::abs(etaSc)<0.8 && mva > 0.87) || (std::abs(etaSc)>=0.8 && std::abs(etaSc)<1.479 && mva > 0.30) || (std::abs(etaSc)>=1.479 && mva >-0.30))) return 1;
  else return 0;
}


float eleWPT(float pt, float etaSc, float mva){
  if (pt<=10 && ((std::abs(etaSc)<0.8 && mva>-0.265) || (std::abs(etaSc)>=0.8 && std::abs(etaSc)<1.479 && mva > -0.556) || (std::abs(etaSc)>=1.479 && mva>-0.551))) return 1;
  else if (pt>10 && ((std::abs(etaSc)<0.8 && mva > 0.87) || (std::abs(etaSc)>=0.8 && std::abs(etaSc)<1.479 && mva > 0.60) || (std::abs(etaSc)>=1.479 && mva >0.17))) return 1;
  else return 0;
}

float eleWPT2017(float pt, float etaSc, float mva, int sostight){
  if (pt<=10) return 1; // branch is not there yet in the current tree
  //if (pt<=10 && ((std::abs(etaSc)<0.8 && mva>-0.133) || (std::abs(etaSc)>=0.8 && std::abs(etaSc)<1.479 && mva > -0.318) || (std::abs(etaSc)>=1.479 && mva>-0.080))) return 1;
  else if (pt>10 && sostight>0) return 1;
  else return 0;
}


std::vector<int> boundaries_runPeriod2017 = {297020,299337,302030,303435,304911};
std::vector<double> lumis_runPeriod2017 = {4.802,9.629,4.235,9.268,13.433};
bool cumul_lumis_runPeriod2017_isInit = false;
std::vector<float> cumul_lumis_runPeriod2017;

int runPeriod2017(int run){
    auto period = std::find_if(boundaries_runPeriod2017.begin(),boundaries_runPeriod2017.end(),[run](const int &y){return y>run;});
    return std::distance(boundaries_runPeriod2017.begin(),period)-1;
}

TRandom3 rand_generator_RunDependentMC2017(0);
int hashBasedRunPeriod2017(int isData, int run, int lumi, int event){
  if (isData) return runPeriod2017(run);
  if (!cumul_lumis_runPeriod2017_isInit){
    cumul_lumis_runPeriod2017.push_back(0);
    float tot_lumi = std::accumulate(lumis_runPeriod2017.begin(),lumis_runPeriod2017.end(),float(0.0));
    for (uint i=0; i<lumis_runPeriod2017.size(); i++) cumul_lumis_runPeriod2017.push_back(cumul_lumis_runPeriod2017.back()+lumis_runPeriod2017[i]/tot_lumi);
    cumul_lumis_runPeriod2017_isInit = true;
  }
  Int_t x = 161248*run+2136324*lumi+12781432*event;
  unsigned int hash = TString::Hash(&x,sizeof(Int_t));
  rand_generator_RunDependentMC2017.SetSeed(hash);
  float val = rand_generator_RunDependentMC2017.Uniform();
  auto period = std::find_if(cumul_lumis_runPeriod2017.begin(),cumul_lumis_runPeriod2017.end(),[val](const float &y){return y>val;});
  return std::distance(cumul_lumis_runPeriod2017.begin(),period)-1;
}
