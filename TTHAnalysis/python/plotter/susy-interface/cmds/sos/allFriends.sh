
## flags (queue, select samples, etc.)
F="-q 1nh --direct --nosplit"
#F="-F --direct --nosplit -q all.q --accept WZTo --exclude amcatnlo --exclude ext"
#F="-F --direct --nosplit -q all.q --accept TChiWZ_200_100 --accept TChiWZ_350_250"
#F="--nosplit --direct -q all.q --accept TChiWZ --accept TChiWH --accept TChiHH --accept TChiHZ --accept TChiZZ4L"
#F="--direct --nosplit -q all.q"

## tree directory
T="/data1/botta/trees_SOS_010217"

## setups
python susy-interface/friendmaker.py sos 2los $T $T --bk --log $F --modules -m both3dloose -m ipjets 

