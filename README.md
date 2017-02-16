# Soundscape-analysis-with-R


## Acoustic diversity indices.r

AcouIndexAlpha(wave, stereo=FALSE, min_freq = 2000, max_freq = 22000, anthro_min = 1000, anthro_max = 2000, bio_min=2000, bio_max=12000, wl=512, j=5, AcouOccupancy=TRUE, Bioac=TRUE, Hf=TRUE, Ht=TRUE, H=TRUE, ACI=TRUE, AEI_villa=TRUE, M=TRUE, NDSI=TRUE, ADI=TRUE, NP=TRUE)


####This code will compute several acoustic diversity indices on a single wav file. This wav file can be stereo or mono. This function calls the packages "seewave" (Sueur et al. 2008a), "tuneR" (Ligges et al. 2016) and, "soundecology" (Villanueava-Rivera and Pijanowski 2016)

###Arguments

####wave 
a R wave object (see the function "readWave" in the "tuneR" package)

####stereo 
if "FALSE" the function will consider only the left channel of a stereo wave file or the only channel of a mono wave file.
If "TRUE" the function will calculate the indices on both channels of a stereo wave file separately. Set as "FALSE" by default.

####min_freq
minimum frequency in hz. Set by default at 2000 Hz.

####max_freq
maximum frequency in hz. Set by default at 22000 Hz.

####anthro_min  
minimum frequency of anthrophony used to calculate the Normalized Difference Soundscape Index (NDSI) from Kasten et al. (2012). Set by default at 1000 Hz 

####anthro_max  
maximum frequency of anthrophony used only to calculate the Normalized Difference Soundscape Index (NDSI) from Kasten, et al. (2012). Set by default at 2000 Hz

####bio_min  
minimum frequency of biophony used only to calculate the Normalized Difference Soundscape Index (NDSI) from Kasten, et al. (2012). Set by default at 2000 Hz

####bio_max  
maximum frequency of biophony used only to calculate the Normalized Difference Soundscape Index (NDSI) from Kasten, et al. (2012). Set by default at 12000 Hz 

####wl  
window length for the spectrogram analysis (even number of points). Set by default at 512 samples 

####j
temporal steps used only for the Acoustic Complexity Index (ACI) calculation from Pieretti et al. (2102). Set by default at 5 seconds

####AcouOccupancy
if TRUE, will calculate the acoustic occupancy index. This index calculate the number of temporal sample in the spectrogram above a threshold of 50 DBA 

####Bioac
if TRUE, will calculate Bioacoustic index (Boelman et al. 2007) by calling the bioacoustic_index function from the soundecology package.

####Hf
if TRUE, will calculate the frequency Entropy (Hf; Sueur et al. 2008b) by calling the "sh" function from the "seewave" package.

####Ht
if TRUE, will calculate the temporal Entropy (Ht; Sueur et al. 2008b) by calling the "env" function from the "seewave" package.

####H
if TRUE, will calculate the Entropy index (H; Sueur et al. 2008b) by calling the "sh" and "env" function from the "seewave" package.

####ACI
if TRUE, will calculate the Acoustic Complexity Index (ACI; Pieretti et al. 2011) by calling the "acoustic_complexity" function from the "soundecology" package.,

####AEI_villa
if TRUE, will calculate the Acoustic Eveness index (AEI; Villanueva-Rivera et al. 2011) by calling the "acoustic_evenness" function from the package "soundecology"

####M
if TRUE, will calculate the Median of amplitude enveloppe (M; Depraetere et al. 2012) by calling the function "env" from the "seewave" package

####NDSI
if TRUE, will calculate the Normalised Difference Soundscape Index (NDSI; Kasten et al. 2012) by calling the function "ndsi" from the "soundecology" package

####ADI
if TRUE, will calculate the Acoustic diversity index (ADI in Pekin et al. 2013 or H' in Villanueva-Riviera et al. 2011) by calling the function "acoustic_diversity" in the "soundecology" package

####NP
if TRUE, will calculate the Number of frequency Peaks (NP; Gasc et al. 2013) by calling the function "fpeaks" in the "seewave" package

### Details


### Value
This function will return a list of two table. The first table is for the "left channel" or "mono channel" and the second table for the "right channel". In case of STEREO=FALSE, the second table will be filled with NA value.

### Example

library(soundecology)
data(tropicalsound)

Result<-AcouIndexAlpha(tropicalsound, stereo=FALSE, min_freq = 2000, max_freq = 10000, anthro_min = 1000, anthro_max = 2000, bio_min=2000, bio_max=12000, wl=512, j=5, AcouOccupancy=TRUE, Bioac=TRUE, Hf=TRUE, Ht=TRUE, H=TRUE, ACI=TRUE, AEI_villa=TRUE, M=TRUE, NDSI=TRUE, ADI=TRUE, NP=TRUE)

Result_left<-Result$Table_left


### References

Boelman, N. T., G. P. Asner, P. J. Hart, and R. E. Martin (2007). Multi-trophic invasion resistance in Hawaii: Bioacoustics, field surveys, and airborne remote sensing. Ecological Applications 17:2137–2144. 

Depraetere, M., S. Pavoine, F. Jiguet, A. Gasc, S. Duvail, and J. Sueur (2012). Monitoring animal diversity using acoustic indices: Implementation in a temperate woodland. Ecological Indicators 13:46–54. 

Gasc, A., J. Sueur, S. Pavoine, R. Pellens, and P. Grandcolas (2013). Biodiversity sampling using a global acoustic approach: Contrasting sites with microendemics in New Caledonia. PLOS One 8:e65311. doi:10.1371/journal.pone. 0065311 

Kasten, Eric P., Stuart H. Gage, Jordan Fox, and Wooyeong Joo. 2012. The Remote Environmental Assessment Laboratory's Acoustic Library: An Archive for Studying Soundscape Ecology. Ecological Informatics 12: 50-67. doi: 10.1016/j.ecoinf.2012.08.001 

Ligges,U., S. Krey, O. Mersmann, and S. Schnackenberg (2016). tuneR: Analysis of music. URL: http://r-forge.r-project.org/projects/tuner/.

Pieretti, N., A. Farina, and D. Morri (2011). A new methodology to infer the singing activity of an avian community: The Acoustic Complexity Index (ACI). Ecological Indicators 11: 868–873. 

Sueur J., T. Aubin, and C. Simonis (2008a). Seewave: a free modular tool for sound analysis and synthesis.
Bioacoustics, 18: 213-226

Sueur, J., S. Pavoine, O. Hamerlynck, and S. Duvail (2008b). Rapid acoustic survey for biodiversity appraisal. PLOS One 3:e4065. 

Villanueva-Rivera, L.J., and B.C. Pijanowski (2016). soundecology: Soundscape Ecology. R package version 1.3.2. https://CRAN.R-project.org/package=soundecology

Villanueva-Rivera, L. J., B. C. Pijanowski, J. Doucette, and B. Pekin. 2011. A primer of acoustic analysis for landscape ecologists. Landscape Ecology 26: 1233-1246. doi: 10.1007/s10980-011-9636-9.

