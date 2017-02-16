# Soundscape-analysis-with-R

## Acoustic diversity indices.r

This code will compute several acoustic diversity indices on a single wav file. This wav file can be stereo or mono.
There are three type of arguments different arguments to enter to run this function:

###Arguments

"wave"a R wave object (see the function "readWave" in the "tuneR" package)

"stereo": If "FALSE" the function will consider only the left channel of a stereo wave file or the only channel of a mono wave file.
If "TRUE" the function will calculate the indices on both channels of a stereo wave file separately. Set as "FALSE" by default.

"min_freq": the minimum frequency in hz. Set by default at 2000 Hz.

"max_freq": the maximum frequency in hz. Set by default at 22000 Hz.

anthro_min = 1000: 
anthro_max = 2000:
bio_min=2000:
bio_max=12000: 
wl=512, 
j=5, 

AcouOccupancy=TRUE,
Bioac=TRUE,
Hf=TRUE,
Ht=TRUE,
H=TRUE,
ACI=TRUE,
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
