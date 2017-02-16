# Soundscape-analysis-with-R

AcouIndexAlpha(wave, stereo=FALSE, min_freq = 2000, max_freq = 22000,anthro_min = 1000, anthro_max = 2000,bio_min=2000,bio_max=12000, wl=512, j=5, AcouOccupancy=TRUE,Bioac=TRUE,Hf=TRUE,Ht=TRUE,H=TRUE,ACI=TRUE,AEI_villa=TRUE,M=TRUE,NDSI=TRUE,ADI=TRUE,NP=TRUE)


## Acoustic diversity indices.r

This code will compute several acoustic diversity indices on a single wav file. This wav file can be stereo or mono.
There are three type of arguments different arguments to enter to run this function:

###Arguments

"wave" a R wave object (see the function "readWave" in the "tuneR" package)

"stereo" if "FALSE" the function will consider only the left channel of a stereo wave file or the only channel of a mono wave file.
If "TRUE" the function will calculate the indices on both channels of a stereo wave file separately. Set as "FALSE" by default.

"min_freq" minimum frequency in hz. Set by default at 2000 Hz.

"max_freq" maximum frequency in hz. Set by default at 22000 Hz.

"anthro_min"  minimum frequency of anthrophony used in the Bioacoustic Index calculation (see Boelman et al. 2007). Set by default at 1000 Hz 

"anthro_max"  maximum frequency of anthrophony used in the Bioacoustic Index calculation (see Boelman et al. 2007). Set by default at 2000 Hz

"bio_min"  minimum frequency of biophony used in the Bioacoustic Index calculation (see Boelman et al. 2007). Set by default at 2000 Hz

"bio_max"  maximum frequency of biophony used in the Bioacoustic Index calculation (see Boelman et al. 2007). Set by default at 12000 Hz 

"wl"  window length for the spectrogram analysis (even number of points). Set by default at 512 samples 

"j"  temporal steps used for the ACI calculation (see Pieretti et al. 2102). Set by default at 5 seconds 

AcouOccupancy if TRUE will calculate the acoustic occupancy index.
Bioac if TRUE will calculate Bioacoustic index (boelman et al. 2007) by calling the bioacoustic_index function from the soundecology package.
Hf if TRUE will calculate the Entropy frequency index by calling the sh function from the seewave package.
Ht if TRUE will calculate the Entropy temporal index by calling the th function from the seewave package.
H if TRUE will calculate the Entropy index by calling the sh and th function from the seewave package.
ACI if TRUE will calculate the Acoustic complexity index by calling the aci_index function from the soundecology package.,
AEI_villa=TRUE,
M=TRUE,
NDSI=TRUE,
ADI=TRUE,
NP=TRUE

### Example:



###Arguments used for the calculation of the Bioacoustic Index (Boelman et al. 2007)


###


###
)
{
