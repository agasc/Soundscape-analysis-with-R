###########################################################################################################################################################
# Pumilio Data Preparation for the Sonic Time-lapse 2/2 (optional, only if you need to average on several directories). Author Amandine Gasc, 20160921.

#-# Description of this code
# The software Sonic Time Lapse have been developped by Benjamin Gottesman and Mark Durham. It is creating a Audio file by concatainating several .wav files. 
# To use Sonic Time Lapse program, you will need to drag a directory conatining .these files. 
# A code  ("SonicTimeLapse_Data_preparation.r") will help you to preapre these directory from the Pumilio Database in order to have clean time series of files for a seasonality (along month, by default it will consider all the months) or daily variation (along hour of the day, by default it will consider all hours).
# This code will help you to average theses along different subdirectory based on a factor (can be among days of a site or among site of a factor) 

#-# Description of the arguments
# DirectoryFrom : character directory path of the results from the function STL_DataPrepFromPumilio. Need to be one more directory level in it and the same number of files in each of these subdirectories.
# DirectoryTo : character directory path of the results you will obtained
# TableFactorAveraged : a table of two column, the first one is the directory name and the second one is the factor associated to it.

# ## Example for different days of a site:
# DirectoryFrom="C:/Users/gamandin/Desktop/DayJune/H1-NO-R2"#res from the function STL_DataPrepFromPumilio. Should be a directory with directories inside corresponding to the sites
# DirectoryTo="C:/Users/gamandin/Desktop/DayJuneAveraged/H1-NO-R2" # a new dorectory to save the averaged files 
# TableFactorAveraged=cbind(Sites=dir("C:/Users/gamandin/Desktop/DayJune/H1-NO-R2"),Factor=c("201406","201406","201406","201406","201406")) # This table of two columns, the first one are the directory/sites names, the second column report the factor to consider, here the type of habitat
# STLDataPrepAverage(DirectoryFrom=DirectoryFrom,DirectoryTo=DirectoryTo,TableFactorAveraged=TableFactorAveraged)


# ## Example for different sites based on a factor disturbance level
# DirectoryFrom="C:/Users/gamandin/Desktop/YearSTL"#res from the function STL_DataPrepFromPumilio. Should be a directory with directories inside corresponding to the sites
# DirectoryTo="C:/Users/gamandin/Desktop/YearSTL_averaged" # a new dorectory to save the averaged files 
# TableFactorAveraged=cbind(Sites=dir("C:/Users/gamandin/Desktop/YearSTL"),Factor=c("H1-HI","H1-HI","H1-HI","H1-NO","H1-NO","H1-NO","H2-HI","H2-HI","H2-HI","H2-NO","H2-NO","H2-NO","H3-ME","H3-ME","H3-ME","H3-NO","H3-NO","H3-NO","H4-HI","H4-HI","H4-HI","H4-NO","H4-NO","H4-NO")) # This table of two columns, the first one are the directory/sites names, the second column report the factor to consider, here the type of habitat
# STLDataPrepAverage(DirectoryFrom=DirectoryFrom,DirectoryTo=DirectoryTo,TableFactorAveraged=TableFactorAveraged)

STLDataPrepAverage<-function(DirectoryFrom=DirectoryFrom,DirectoryTo=DirectoryTo,TableFactorAveraged=TableFactorAveraged)
	{
	#load the packages
	require(pumilioR)
	require(tuneR)
	require(seewave)

	Fact<-unique(TableFactorAveraged[,2])
	
	for (i in 1:length(Fact))
		{
		dir.create(paste(DirectoryTo,Fact[i],sep="/"),showWarnings = FALSE)
		DirectoriesFact<-TableFactorAveraged[TableFactorAveraged[,2]==Fact[i],]
		DirectoriesFactPath<-paste(DirectoryFrom,"/",DirectoriesFact[,1],sep="")
		
			
		#check number of files in the directories should be similar
		FileNumbers<-NULL
		for (j in 1: nrow(DirectoriesFact))
			{
			FileNumbers<-c(FileNumbers,length(dir(DirectoriesFactPath[j])))
			}
		if (length(unique(FileNumbers))!=1)
		{stop="file numbers are not somilar in the directories to averaged"}
		
		#Create the average per similar files
		
		for (k in 1:FileNumbers[1])
		{
		print(k)
			#how many files for the k type of file. we need to exclude the NASilence in this average
			N=0
			for (g in 1:length(FileNumbers))
			{
			if (length(unlist(strsplit(dir(DirectoriesFactPath[g])[k],"NASilence")))!=2)
				{
				N<-N+1
				}
			}
			ratio<-N
			
			WaveF<-0
			for (g in 1:length(FileNumbers))
			{
			if(length(unlist(strsplit(dir(DirectoriesFactPath[g])[k],"NASilence")))!=2)
			{
			WaveF<-WaveF+readWave(paste(DirectoriesFactPath[g],"/",dir(DirectoriesFactPath[g])[k],sep=""))/ratio
			} 
			}
		
		Date<-paste(substr(strsplit(dir(DirectoriesFactPath[g])[k],"_")[[1]][2],1,6),"XX",sep="")
		Time<-strsplit(dir(DirectoriesFactPath[g])[k],"_")[[1]][3]
			if(ratio!=0){
			writeWave(WaveF,file=paste(DirectoryTo,"/",Fact[i],"/",Fact[i],"_",Date,"_",Time,"_",k,".wav",sep=""))} else {
			file.copy(from=paste(DirectoriesFactPath[g],"/",dir(DirectoriesFactPath[g])[k],sep=""),to=paste(DirectoryTo,"/",Fact[i],"/",Fact[i],"_",Date,"_",Time,"_",k,"_","NASilence.wav",sep=""))
			}
		}
	}
	}
	