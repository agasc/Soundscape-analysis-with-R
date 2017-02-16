#####################################
#Global acoustic indices calculation#
#####################################

# Authors: amandine gasc: amandine.gasc@gmail.com


# slight modification of the fpeak function from the "seewave" package.
fpeaksFlat<-function (spec, f = NULL, nmax = NULL, amp = NULL, freq = NULL, 
    threshold = NULL, plot = TRUE, title = TRUE, xlab = "Frequency (kHz)", 
    ylab = "Amplitude", labels = TRUE, legend = TRUE, collab = "red", 
    ...) 
{
    if (is.matrix(spec)) {
        if (ncol(spec) != 2) 
            stop("If 'spec' is a numeric matrix it should be a two column matrix with the first colum describing the frequency x-axis and the second column describing the amplitude y-axis")
        N <- nrow(spec)
    }
    if (is.vector(spec)) {
        N <- length(spec)
        if (is.null(f)) {
            stop("If 'spec' is a numeric vector describing the amplitude only, the sampling frequency 'f' of the original signal should be provided (for instance (f = 44100)")
        }
        if (!is.null(f) && !is.na(f)) {
            spec <- cbind(seq(f/(N * 2), f/2, length = N)/1000, 
                spec)
        }
        if (!is.null(f) && is.na(f)) {
            spec <- cbind(1:N, spec)
            plot <- FALSE
        }
    }
    flat <- round(N/20)
    spec.tmp <- c(spec[, 2], rep(NA, flat))
    for (i in 1:(N - (flat + 1))) {
        ref <- spec.tmp[i]
        for (j in 1:flat) {
            if (spec.tmp[i + j] == ref) {
                spec.tmp[i + j] <- spec.tmp[i + j] + 1e-05 * 
                  spec.tmp[i + j]
            }
        }
    }
    spec <- cbind(spec[, 1], spec.tmp[1:N])
	sym <- discrets(spec[, 2], symb = 5, collapse = FALSE)
    
	# si ya des flats
	specF<-spec
	for (mod in 1:length(specF[,2]))
	{
	if(specF[mod,2]==0){specF[mod,2]<-specF[mod,2]+0.000001*mod}
	}
	sym2 <- discrets(specF[, 2], symb = 5, collapse = FALSE)
	#
	
	if (sym2[1] == "I") 
        sym2[1] <- "T"
    if (sym2[1] == "P") 
        sym2[1] <- "D"
	
    sym2 <- c(NA, sym2, NA)
    peaks <- which(sym2 == "P")
    valleys <- which(sym2 == "T")
	
    n <- length(peaks)
    if (n == 0) {
        res <- NA
        plot <- FALSE
    }    else {
        if (!is.null(amp) | !is.null(nmax)) {
            diffvp <- diffpv <- numeric(n)
            for (i in 1:n) {
                v <- specF[valleys[i], 2]
                p <- specF[peaks[i], 2]
                vv <- specF[valleys[i + 1], 2]
				diffvp[i] <- p - v
                diffpv[i] <- p - vv
            }
        }
        if (!is.null(nmax) && n != 0) {
            if (!is.null(amp) | !is.null(freq) | !is.null(threshold)) {
                cat("Caution! The argument 'nmax' overrides the arguments 'amp', 'freq', and 'threshold'")
            }
            if (n < nmax) {
                cat(paste("There are", n, "peaks only (< nmax ="), 
                  nmax, ")")
            }
            if (nmax == 1) {
                tmp <- specF[peaks, , drop = FALSE]
                res <- tmp[which.max(tmp[, 2]), , drop = FALSE]
            }            else {
                alt <- cbind(peaks, diffvp, diffpv)
                leftorder <- alt[order(-alt[, 2]), , drop = FALSE]
                rightorder <- alt[order(-alt[, 3]), , drop = FALSE]
                left <- leftorder[, 1]
                right <- rightorder[, 1]
                l <- 0
                i <- 1
                while (l[i] < nmax) {
                  comp <- left[1:i] %in% right[1:i]
                  l <- c(l, length(comp[comp == TRUE]))
                  i <- i + 1
                }
                peaks0 <- left[1:(i - 1)]
                if (l[i] > nmax) {
                  error <- l[i] - nmax
                  peaks0 <- peaks0[1:(length(peaks0) - error)]
                }
                peaks <- peaks0[comp]
                res <- matrix(na.omit(specF[peaks, ]), nc = 2)
                colnames(res) <- c("freq", "amp")
            }
        } else {
            if (!is.null(amp)) {
                if (length(amp) != 2) 
                  stop("The length of 'amp' should equal to 2.")
                for (i in 1:n) {
                  if (!is.na(diffvp[i]) && !is.na(diffpv[i]) && 
                    diffvp[i] > 0 && diffpv[i] > 0 && diffvp[i] >= 
                    amp[1] && diffpv[i] >= amp[2]) 
                    peaks[i] <- peaks[i]
                  else peaks[i] <- NA
                }
            }
            if (!is.null(freq)) {
                freq <- freq/1000
                diffpeak <- numeric(n - 1)
                for (i in 1:(n - 1)) {
                  peak1 <- specF[peaks[i], 1]
                  peak2 <- specF[peaks[i + 1], 1]
                  diffpeak[i] <- peak2 - peak1
                  if (!is.na(diffpeak[i]) && diffpeak[i] <= freq) 
                    if (specF[peaks[i + 1], 2] > specF[peaks[i], 
                      2]) 
                      {peaks[i] <- NA}  else peaks[i + 1] <- NA
                }
            }
            if (!is.null(f) && is.na(f)) {
                res <- peaks
            }            else {
                res <- matrix(na.omit(specF[peaks, ]), nc = 2)
                colnames(res) <- c("freq", "amp")
            }
            if (!is.null(threshold)) {
                res <- res[res[, 2] > threshold, , drop = FALSE]
            }
        }
    }
    if (plot) {
        plot(spec, type = "l", xlab = xlab, ylab = ylab, xaxs = "i", 
            yaxt = "n", ...)
        if (title) {
            if (nrow(res) == 1) {
                text.title <- "peak detected"
            }            else {
                text.title <- "peaks detected"
            }
            title(main = paste(nrow(res), text.title))
        }
        points(res, col = collab)
        if (labels & nrow(res) != 0) 
            text(res, labels = round(res[, 1], 2), pos = 3, col = collab)
        if (!is.null(threshold)) {
            abline(h = threshold, col = collab, lty = 2)
            mtext(paste(threshold), side = 2, line = 0.5, at = threshold, 
                las = 1, col = collab)
        }
        if (legend) {
            if (!is.null(nmax)) {
                text.legend <- paste("nmax=", nmax, sep = "")
            }            else {
                if (is.null(amp)) {
                  amp[1] <- amp[2] <- "-"
                }                else amp <- round(amp, 2)
                if (is.null(freq)) {
                  freq <- "-"
                }
                if (is.null(threshold)) {
                  threshold <- "-"
                }
                text.legend <- c(paste("amp=", amp[1], "/", amp[2], 
                  sep = ""), paste("freq=", freq, sep = ""), 
                  paste("threshold=", threshold, sep = ""))
            }
            legend("topright", pch = NA, legend = text.legend, 
                bty = "n", text.col = "darkgrey")
        }
        invisible(res)
    }    else return(res)
}



#############################
#############################

AcouIndexAlpha<-function(wave, stereo=FALSE, min_freq = 2000, max_freq = 22000,anthro_min = 1000, anthro_max = 2000,bio_min=2000,bio_max=12000, wl=512, j=5, AcouOccupancy=TRUE,Bioac=TRUE,Hf=TRUE,Ht=TRUE,H=TRUE,ACI=TRUE,AEI_villa=TRUE,M=TRUE,NDSI=TRUE,ADI=TRUE,NP=TRUE)
{
library(seewave)
library(tuneR)
library(soundecology)

#arguments fpeak
amp=c(1/90,1/90)
freq=200
plotpic=FALSE

f<-wave@samp.rate
nyquist_freq <- f/2

left <- channel(wave, which = c("left"))
spec_left <- spectro(left, f = samplingrate, wl = wl, plot = FALSE, dB = "max0")$amp
specA_left <- apply(spec_left, 1, meandB)
rows_width = length(specA_left) / nyquist_freq
min_row = round(min_freq * rows_width)
max_row = round(max_freq * rows_width)
specA_left_segment <- specA_left[min_row:max_row]
freqs <- seq(from = min_freq, to = max_freq, length.out = length(specA_left_segment))
specA_left_segment_normalized<-(specA_left_segment-min(specA_left_segment))/max(specA_left_segment-min(specA_left_segment))
spec_L<-cbind(freqs,specA_left_segment_normalized)

if(wave@stereo==TRUE)
	{
	right<- channel(wave, which = c("right"))
	spec_right <- spectro(right, f = samplingrate, wl = wl, plot = FALSE, dB = "max0")$amp
	specA_right <- apply(spec_left, 1, meandB)
	specA_right_segment <- specA_right[min_row:max_row]
	specA_right_segment_normalized<-(specA_right_segment-min(specA_right_segment))/max(specA_right_segment-min(specA_right_segment))
	spec_R<-cbind(freqs,specA_right_segment_normalized)
	}

Table_left<-NULL
Table_right<-NULL

###################################################################
#Accupancy_index ref???. This index has been proposed by Bryan Pijanowski but have never been published.
if(AcouOccupancy==TRUE)
	{
	Spectrogram_Aleft<-spectro(left, f = samplingrate, wl = wl, plot = FALSE, dB = "A")$amp
	Spectrogram_Aleft_segment <- Spectrogram_Aleft[min_row:max_row, ]
	vec_left<-NULL
	for (i in 1:ncol(Spectrogram_Aleft_segment))
		{
		if(any(na.omit(Spectrogram_Aleft_segment[,i])>-50)){vec_left<-c(vec_left,1)} else{vec_left<-c(vec_left,0)}
		}
	AcouOccupancy_left<-length(vec_left[vec_left==1])/length(vec_left)
	Table_left<-cbind(Table_left,AcouOccupancy_left)
		
	if(wave@stereo==TRUE)
	{
	Spectrogram_Aright<-spectro(right, f = samplingrate, wl = wl, plot = FALSE, dB = "A")$amp
	Spectrogram_Aright_segment <- Spectrogram_Aright[min_row:max_row, ]
	vec_right<-NULL
	for (i in 1:ncol(Spectrogram_Aright_segment))
		{
		if(any(na.omit(Spectrogram_Aright_segment[,i])>-50)){vec_right<-c(vec_right,1)} else{vec_right<-c(vec_right,0)}
		}
	AcouOccupancy_right<-length(vec_right[vec_right==1])/length(vec_right)
	Table_right<-cbind(Table_right,AcouOccupancy_right)
	} 
		
	}




###################################################################
# Relative avian abondance - (Boelman et al. 2007)
#calculation of the dB en fonction to the frequency=meanspectrum db using
#then calculation of the area under the spectrum dB
if(Bioac==TRUE)
{
bioacouMeasure<-bioacoustic_index(wave, min_freq = min_freq, max_freq = max_freq, fft_w = wl)
Bioac_left<-bioacouMeasure$left_area
Table_left<-cbind(Table_left,Bioac_left)
if(wave@stereo==TRUE)
	{
	Bioac_right<-bioacouMeasure$right_area
	Table_right<-cbind(Table_right,Bioac_right)
	}
}


###################################################################
#Temporal entropy - Ht (Sueur et al. 2008)
if(Ht==TRUE)
	{
	 th2<-function (env) 
		{
		options(warn = -1)
		if (is.na(env)) 
		z <- 0
		else {
		options(warn = 0)
		if (any(env < 0, na.rm = TRUE)) 
			stop("data must be an envelope, i. e. a vector including positive values only.")
		N <- length(env)
		env <- env/sum(env)
		if (any(is.nan(env))) 
			{
			warning("Caution! There is no signal in this data set! The temporal entropy is null!", call. = FALSE)
			return(0)
			}
		if (sum(env)/(N * env[1]) == 1 | sum(env)/N == 1) 
			{
			warning("Caution! This is a square signal. The temporal entropy is null!", call. = FALSE)
			return(0)
			}
		env[env == 0] <- 1e-07
		env <- env/sum(env)
		z <- -sum(env * log(env))/log(N)
		}
		return(z)
	}

	env_left<-env(wave@left,f,plot=F,envt="abs")
	env_left<-env_left/sum(as.numeric(env_left))
	Ht_left<-th2(env_left)
	Table_left<-cbind(Table_left,Ht_left)
	if(wave@stereo==TRUE)
		{
		env_right<-env(wave@right,f,plot=F,envt="abs")
		env_right<-env_right/sum(as.numeric(env_right))
		Ht_right<-th2(env_right)
		Table_right<-cbind(Table_right,Ht_right)
		}
	}




###################################################################
# Spectral entropy - Hf  (Sueur et al. 2008)
if(Hf==TRUE)
	{
	Hf_left<-sh(spec_L)
	Table_left<-cbind(Table_left,Hf_left)
	if(wave@stereo==TRUE)
		{
		Hf_right<-sh(spec_R)
		Table_right<-cbind(Table_right,Hf_right)
		}
	}




###################################################################
# Acoustic Entropy index - H (Sueur et al. 2008, joo et al. 2011)
if(H==TRUE)
	{
	H_left=Hf_left*Ht_left
	Table_left<-cbind(Table_left,H_left)
		if(wave@stereo==TRUE)
			{
			H_right=Hf_right*Ht_right
			Table_right<-cbind(Table_right,H_right)
			}
	}


###################################################################
# ACI (Pieretti et al. 2011) ACI() {seewave} A REVOIR A PAROPOS DES FILTRES
# Issue with the j with short sound# maybe by default =1 ???
if(ACI==TRUE)
	{
	ACI_measure<-acoustic_complexity(wave,max_freq = max_freq, j = j, fft_w = wl)
	ACI_left<-ACI_measure$AciTotAll_left
	Table_left<-cbind(Table_left,ACI_left)
	if(wave@stereo==TRUE)
			{
			ACI_right<-ACI_measure$AciTotAll_right
			Table_right<-cbind(Table_right,ACI_right)
			}
	}


###################################################################
# Acoustic Evenness Index (AEI)== H'(Villanueva-Rivera et al. 2011) acoustic_evenness(TropicalSound)
if(AEI_villa==TRUE)
	{
	AEI_villa_measure<-acoustic_evenness(wave, max_freq = max_freq, db_threshold = -50, freq_step = 1000)
	AEI_villa_left<-AEI_villa_measure$aei_left
	Table_left<-cbind(Table_left,AEI_villa_left)
	if(wave@stereo==TRUE)
				{
				AEI_villa_right<-AEI_villa_measure$aei_right
				Table_right<-cbind(Table_right,AEI_villa_right)
				}
	}


###################################################################
# Median of amplitude envelope - M (Depraetere et al. 2012)
if(M==TRUE)
	{
	bit=wave@bit
	env_left<-env(wave@left,f,plot=F,envt="abs")
	env_left<- env_left/sum(as.numeric(env_left)) 
	M_left<-median(env_left)*(2^(1-bit))
	Table_left<-cbind(Table_left,M_left)
	if(wave@stereo==TRUE)
				{
				bit=wave@bit
				env_right<-env(wave@right,f,plot=F,envt="abs")
				env_right<- env_right/sum(as.numeric(env_right)) 
				M_right<-median(env_right)*(2^(1-bit))
				Table_right<-cbind(Table_right,M_right)
				}
	}



###################################################################
# Normalised difference soundscape index - NDSI (Kasten et al. 2012)
if(NDSI==TRUE)
{
NDSI_measure<-ndsi(wave, fft_w = wl, anthro_min = 1000, anthro_max = 2000,bio_min = bio_min, bio_max = bio_max)
NDSI_left<-NDSI_measure$ndsi_left
#NDSI_seewave<-NDSI(soundscapespec(wave))
Table_left<-cbind(Table_left,NDSI_left)

	if(wave@stereo==TRUE)
		{
		NDSI_right<-NDSI_measure$ndsi_right
		Table_right<-cbind(Table_right,NDSI_right)
		}
}







###################################################################
# Acoustic diversity index - ADI (=H') (Pekin et al. 2013)// H' (Villanueva-Riviera et al. 2011)
if(ADI==TRUE)
{
ADI_measure<-acoustic_diversity(wave,max_freq = max_freq, db_threshold = -50, freq_step = 1000,shannon = TRUE)
ADI_left<-ADI_measure$adi_left
Table_left<-cbind(Table_left,ADI_left)

	if(wave@stereo==TRUE)
			{
			ADI_right<-ADI_measure$adi_right
			Table_right<-cbind(Table_right,ADI_right)
			}
}




###################################################################
# Number of peaks - NP (Gasc et al. 2013b)
if(NP==TRUE)
	{
	res1_left <- fpeaksFlat(spec_L,plot=F,f)
	pictot_left<-nrow(res1_left)

	if(is.null(pictot_left)==FALSE)
		{
			if(pictot_left!=1)
			{
			res2_left<-fpeaksFlat(spec_L,amp=amp,freq=freq,plot=plotpic,f)
			npic_left<-nrow(res2_left)
			}else{
			res2_left<-fpeaksFlat(spec_left,plot=plotpic,f)
			npic_left<-nrow(res2_left)
			}
		}else{
		npic_left<-0
		}
		Table_left<-cbind(Table_left,npic_left)
		
	if(wave@stereo==TRUE)
		{
		res1_right <- fpeaksFlat(spec_R,plot=F,f)
		pictot_right<-nrow(res1_right)
		
		if(is.null(pictot_right)==FALSE)
		{
			if(pictot_right!=1)
			{
			res2_right<-fpeaksFlat(spec_R,amp=amp,freq=freq,plot=plotpic,f)
			npic_right<-nrow(res2_right)
			}else{
			res2_right<-fpeaksFlat(spec_right,plot=plotpic,f)
			npic_right<-nrow(res2_right)
			}
		}else{
		npic_right<-0
		}
		Table_right<-cbind(Table_right,npic_right)
		}
	}


Table_left<-as.data.frame(Table_left)
Table_right<-as.data.frame(Table_right)
if(stereo==FALSE) 
{
Table_right<-Table_left
Table_right[]<-NA
}
Result<-list(Table_left,Table_right)
names(Result)<-c("Mono_left","Mono_right")
return(Result)
}


