###########################################################################################################################################################
# Pumilio Data Preparation for the Sonic Time-lapse 1/2. Author Amandine Gasc, 20160921.

#-# Description of this code
# The software Sonic Time Lapse have been developped by Benjamin Gottesman and Mark Durham. It is creating a Audio file by concatainating several .wav files. 
# To use Sonic Time Lapse program, you will need to drag a directory conatining .these files. 
# This code will help you to preapre these directory from the Pumilio Database in order to have clean time series of files for a seasonality (along month, by default it will consider all the months) or daily variation (along hour of the day, by default it will consider all hours).

#-# Description of the arguments
#pumilio_URL				# Address of the pumilio database
#Colname 					# Character, the collection name in Pumilio example: "Arizona 2013"
#SiteNames	 				# Vector of character, names of the sites in Pumilio: c("H1-HI-R1","H1-HI-R2") 
#pathFlacFronten		 	# Character, the path where you have the flac2wav software see ?wac2wav
#Directory					# Character, path of your temporary directory where you will have you files copied and transformed
#DurationFile			   	# Interger, the Duration final of the file in seconds, if empty you will concerve the original duration 
#STL_type					# Character, either "STLd" for Sonic Time Lapse daily or "STLy" for sonic timelapse yearly
#STLy_Hour					# Character, representing ONE hours of the day, example: "00" for midnight, "09" for 9 a.m. or "22" for 10 p.m. 
#STLy_Nfiles				# Integer, representing the number of files per month, equivalent of the number of days represented
#STLy_Month==NULL			# Vector of character representing the month: example: c("01","02","03") for a time lapse containing the month pf January to March. if NULL it will consider all the month from January to December. 
#STLd_Month					# Character, representing ONE Month of the year, example: "01" for January or "10" for October
#STLd_Ndays					# Integer, representing the number of days, one folder will be created with the 24 hours of these days randomly sampled.
#STLd_Hours==NULL			# Vector of character representing the Hours: example: c("00","02","03") for a time lapse containing the Hours from midnight to 3 a.m. if NULL it will consider all the hours of the day. 
#FactorQuality			    # Vector of  TRUE/FALSE follwing the filenames of the recordings to consider; For example you have information about wind, rain and/or technical issue: so information about how to exclude sounds from the selection


#-# Example 1: STLy
# pumilio_URL="http://soundscape01.rcac.purdue.edu/pumilio/"
# Colname="Arizona 2013"
# SiteNames<-c("H1-HI-R1","H1-HI-R2", "H1-HI-R3", "H1-NO-R1", "H1-NO-R2", "H1-NO-R3", "H2-HI-R1", "H2-HI-R2", "H2-HI-R3", "H2-NO-R1", "H2-NO-R2", "H2-NO-R3", "H3-LO-R1", "H3-LO-R2", "H3-LO-R3", "H3-ME-R1", "H3-ME-R2", "H3-ME-R3", "H3-NO-R1", "H3-NO-R2", "H3-NO-R3", "H4-HI-R1", "H4-HI-R2", "H4-HI-R3", "H4-NO-R1", "H4-NO-R2",  "H4-NO-R3") # Set the sites names
# pathFlacFronten<-"C:/Program Files (x86)/FLAC Frontend/tools"
# Directory<-"C:/Users/gamandin/Desktop/DayJune_wind"
# DurationFile<-10
# STL_type = "STLy" 		# this can be Daily or Seasonal: "STLd" or "STLy" 
# STLy_Hour = "06"			#set the time of the day
# STLy_Nfiles = 5 			# set the number of files per month
# STLy_Month<-c("03","04","05","06","07","08","09","10","11")


# STLDataPrepFromPumilio(pumilio_URL=pumilio_URL, Colname=Colname,SiteNames=SiteNames,pathFlacFronten=pathFlacFronten,Directory=Directory,DurationFile=DurationFile,STL_type=STL_type,STLy_Hour=STLy_Hour,STLy_Nfiles=STLy_Nfiles,STLy_Month=STLy_Month)

#-# Example 2: STLd
 # #pumilio_URL="http://soundscape01.rcac.purdue.edu/pumilio/"
 # Colname="Arizona 2013"
 # SiteNames<-c("H1-HI-R1","H1-HI-R2", "H1-HI-R3", "H1-NO-R1", "H1-NO-R2", "H1-NO-R3", "H2-HI-R1", "H2-HI-R2", "H2-HI-R3", "H2-NO-R1", "H2-NO-R2", "H2-NO-R3", "H3-LO-R1", "H3-LO-R2", "H3-LO-R3", "H3-ME-R1", "H3-ME-R2", "H3-ME-R3", "H3-NO-R1", "H3-NO-R2", "H3-NO-R3", "H4-HI-R1", "H4-HI-R2", "H4-HI-R3", "H4-NO-R1", "H4-NO-R2",  "H4-NO-R3") # Set the sites names
 # pathFlacFronten<-"C:/Program Files (x86)/FLAC Frontend/tools"
 # Directory<-"C:/Users/gamandin/Desktop/test"
 # DurationFile<-10
 # STL_type = "STLd" 		# this can be Daily or Seasonal: "STLd" or "STLy" 
 # STLd_Month="06"
 # STLd_Ndays=3
 # STLd_Hours=c("00","01","02","03","04")

# STL_DataPrepFromPumilio(pumilio_URL=pumilio_URL,Colname=Colname,SiteNames=SiteNames,pathFlacFronten=pathFlacFronten,Directory=Directory,DurationFile=DurationFile,STL_type=STL_type,STLd_Month=STLd_Month,STLd_Ndays=STLd_Ndays,STLd_Hours=STLd_Hours)



#FactorQuality<-ListInd_subWind_reorg[[1]][,1]


#-# Example 3: STLd
 # #pumilio_URL="http://soundscape01.rcac.purdue.edu/pumilio/"
 # Colname="Arizona 2013"
 # SiteNames<-c("H1-HI-R1","H1-HI-R2", "H1-HI-R3", "H1-NO-R1", "H1-NO-R2", "H1-NO-R3", "H2-HI-R1", "H2-HI-R2", "H2-HI-R3", "H2-NO-R1", "H2-NO-R2", "H2-NO-R3", "H3-LO-R1", "H3-LO-R2", "H3-LO-R3", "H3-ME-R1", "H3-ME-R2", "H3-ME-R3", "H3-NO-R1", "H3-NO-R2", "H3-NO-R3", "H4-HI-R1", "H4-HI-R2", "H4-HI-R3", "H4-NO-R1", "H4-NO-R2",  "H4-NO-R3") # Set the sites names
 # pathFlacFronten<-"C:/Program Files (x86)/FLAC Frontend/tools"
 # Directory<-"C:/Users/gamandin/Desktop/test"
 # DurationFile<-10
 # STL_type = "STLd" 		# this can be Daily or Seasonal: "STLd" or "STLy" 
 # STLd_Month="06"
 # STLd_Ndays=3
 # STLd_Hours=c("00","01","02","03","04")

# STL_DataPrepFromPumilio(pumilio_URL=pumilio_URL,Colname=Colname,SiteNames=SiteNames,pathFlacFronten=pathFlacFronten,Directory=Directory,DurationFile=DurationFile,STL_type=STL_type,STLd_Month=STLd_Month,STLd_Ndays=STLd_Ndays,STLd_Hours=STLd_Hours)









STL_DataPrepFromPumilio<-function(pumilio_URL,Colname,SiteNames,pathFlacFronten,Directory,DurationFile,STL_type,STLy_Hour,STLy_Nfiles,STLy_Month=NULL,STLd_Month,STLd_Ndays,STLd_Hours=NULL,FactorQuality=NULL)
{

#load the packages
require(pumilioR)
require(tuneR)
require(seewave)
	
# Arguments:

#-# Please to help you finding the site and collection names, enter the two lines below:
cat("Step 1/3. Loading Data from the database. This can take few minutes...", sep="\n")
cat("checking collections info...", sep="\n")
Collections<-getCollections(pumilio_URL="http://soundscape01.rcac.purdue.edu/pumilio/") 

cat("checking sites info...", sep="\n")
Sites<-getSites(pumilio_URL="http://soundscape01.rcac.purdue.edu/pumilio/") 
ColID=Collections[Collections[,2]==Colname,1][[1]]
SiteIDs<-unlist(Sites[Sites[,2]%in%SiteNames,1])
cat("loading sounds info...", sep="\n")
ListAllSounds<-getSounds(pumilio_URL="http://soundscape01.rcac.purdue.edu/pumilio/", SiteID=NA, ColID=ColID, type="col",credentials = NA, pumiliologin = NA)
ListAllSoundsFire<-ListAllSounds[ListAllSounds[,3]%in%SiteIDs,]#subselect the files from the sites
				#ERROR CATCH 1: on verifie qu'il n y ait pas de duplicatation dans les fichiers
				if(any(duplicated(ListAllSounds[,4]))){print("Error, You have replicated rows in your original data base ")}

if(length(FactorQuality)!=0)
	{
	Names1<-NULL
	for(i in 1 :length(unlist(ListAllSoundsFire[,4])))
	{
	if(substr(ListAllSoundsFire[i,4]$sound,nchar(ListAllSoundsFire[i,4]$sound)-3,nchar(ListAllSoundsFire[i,4]$sound))=="flac"){
	Names1<-c(Names1,strsplit(ListAllSoundsFire[i,4]$sound,".f")[[1]][1])} else{Names1<-c(Names1,strsplit(ListAllSoundsFire[i,4]$sound,".w")[[1]][1])}
	}

	Names2<-NULL
	for(i in 1 :length(FactorQuality))
	{
	if(substr(FactorQuality[i],nchar(FactorQuality[i])-3,nchar(FactorQuality[i]))=="flac"){
	Names2<-c(Names2,strsplit(FactorQuality[i],".f")[[1]][1])} else{Names2<-c(Names2,strsplit(FactorQuality[i],".w")[[1]][1])}
	}

	ListAllSoundsFire<-ListAllSoundsFire[Names1%in%Names2,]
	}
				
				
if(STL_type=="STLy")  #----- Annual Variation
	{
	SoundTime<-ListAllSoundsFire[substr(sapply(ListAllSoundsFire[,4],function(x){strsplit(x,"_")[[1]][3]}),1,2)==STLy_Hour,]#subselect again on the time

	#-# Creation of the Table used for copying the files from the database. If missing data, we create a fake name in the column 4 for futur codes
	if(length(STLy_Month)==0)
	{
	STLy_Month=c("01","02","03","04","05","06","07","08","09","10","11","12")
	} 
	
	AllDays<-c("01","02","03","04","05","06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20","21", "22","23", "24", "25","26","27","28","29","30")
	cat("Step 2/3. Creating the list of the files available from the database with selected criteria:", sep="\n")
	pb   <- txtProgressBar(1, length(SiteNames), style=3)
	TableFinal<-NULL
	for(i in 1:length(SiteNames))
		{
		Sys.sleep(0.02)
		setTxtProgressBar(pb, i)
		ListSite<-SoundTime[sapply(SoundTime[,4],function(x){strsplit(x,"_")[[1]][1]})==SiteNames[i],]
		for (j in 1:length(STLy_Month))
			{
			ListSiteMonth<-ListSite[substr(sapply(ListSite[,4],function(x){strsplit(x,"_")[[1]][2]}),5,6)==STLy_Month[j],]
			Days<-substr(sapply(ListSiteMonth[,4],function(x){strsplit(x,"_")[[1]][2]}),7,8)
			if(nrow(ListSiteMonth)>=STLy_Nfiles)
				{
				SS<-sample(nrow(ListSiteMonth),STLy_Nfiles)
				ListSiteMonth_5<-ListSiteMonth[SS,]
				TableFinal<-rbind(TableFinal,ListSiteMonth_5)
				}else{
					Day_substitute<-sample(AllDays[!AllDays%in%Days],STLy_Nfiles-nrow(ListSiteMonth))
					MissingLine<-NULL
					for (k in 1:length(Day_substitute))
						{
						MissingLine<-rbind(MissingLine,c(rep("NA",3),paste(SiteNames[i],paste("2014",STLy_Month[j],Day_substitute[k],sep=""),sep="_"),rep("NA",20)))
						}
					colnames(MissingLine)<-colnames(ListSiteMonth)
					TableFinal<-rbind(TableFinal,ListSiteMonth,MissingLine)
				}
			}
		}


	#-# Copy the files from Pumilio and organize them in one folder per site
	# clean the repertory file.remove(paste(Directory,dir(Directory),sep="/")) TODO
	cat("", sep="\n")
	cat("Step 3/3. Copying and preparing the files from the database to your tmp directory:", sep="\n")
	pb   <- txtProgressBar(1, nrow(TableFinal), style=3)
	for (i in 1:nrow(TableFinal))
		{
		Sys.sleep(0.02)
		setTxtProgressBar(pb, i)
		if(TableFinal[i,1][[1]]!="NA")
			{
			SiteI<-strsplit(TableFinal[i,4][[1]],"_")[[1]][1]
			dir1<-unlist(strsplit(TableFinal$FilePath[[i]],"/"))[7]
			dir2<-unlist(strsplit(TableFinal$FilePath[[i]],"/"))[8]
			dir.create(paste(Directory,SiteI,sep="/"),showWarnings = FALSE)
			if(length(strsplit(TableFinal[i,4][[1]],".f")[[1]])==2) #it is a flac file
				{
				file.copy(from=paste("Z:/web/soundscape01/pumilio/sounds/sounds/",dir1,"/",dir2,"/",TableFinal[i,4][[1]],sep=""),to=paste(Directory,SiteI,paste(strsplit(TableFinal[i,4][[1]],".f")[[1]][1],".flac",sep=""),sep="/"))
				wav2flac(paste(Directory,SiteI,paste(strsplit(TableFinal[i,4][[1]],".f")[[1]][1],".flac",sep=""),sep="/"),reverse=TRUE,overwrite = TRUE,path2exe=pathFlacFronten)
					if(exists('DurationFile')) {
					wav<-readWave(paste(Directory,SiteI,paste(strsplit(TableFinal[i,4][[1]],".f")[[1]][1],".wav",sep=""),sep="/"),from=0,to=DurationFile,units="seconds")
					writeWave(wav,filename=paste(Directory,SiteI,paste(strsplit(TableFinal[i,4][[1]],".f")[[1]][1],"_ModifDuration.wav",sep=""),sep="/"))
					file.remove(paste(Directory,SiteI,paste(strsplit(TableFinal[i,4][[1]],".f")[[1]][1],".wav",sep=""),sep="/"))
					}
				} else {
				file.copy(from=paste("Z:/web/soundscape01/pumilio/sounds/sounds/",dir1,"/",dir2,"/",TableFinal[i,4][[1]],sep=""),to=paste(Directory,SiteI,TableFinal[i,4][[1]],sep="/"))
					if(exists('DurationFile')) {
					wav<-readWave(paste(Directory,SiteI,TableFinal[i,4][[1]],sep="/"),from=0,to=DurationFile,units="seconds")
					writeWave(wav,filename=paste(Directory,SiteI,paste(strsplit(TableFinal[i,4][[1]],".w")[[1]][1],"_ModifDuration.wav",sep=""),sep="/"))
					file.remove(paste(Directory,SiteI,TableFinal[i,4][[1]],sep="/"))
					}
				}
			}
		if(TableFinal[i,1][[1]]=="NA")
			{
			SiteI<-strsplit(TableFinal[i,4][[1]],"_")[[1]][1]
			dir.create(paste(Directory,SiteI,sep="/"),showWarnings = FALSE)
			a<-noisew(d=DurationFile+2,f=44100,output="Wave")
			Silence<-cutw(mutew(a, f=44100, from = 1, to = DurationFile+1,units="seconds", plot = FALSE,output = "Wave"),f=44100,from=1,to=DurationFile+1,units="seconds",output="Wave")
			savewav(Silence,file=paste(Directory,"/",SiteI,"/",TableFinal[i,4][[1]],"_",STLy_Hour,"0000_NASilence.wav",sep=""))
			}
		}
	}


	


#----- Daily Variation, on one specific period of time
if(STL_type=="STLd")	
	{
	
	SoundTime<-ListAllSoundsFire[substr(sapply(unlist(ListAllSoundsFire[,4]),function(x){strsplit(x,"_")[[1]][2]}),5,6)==STLd_Month,]#subselect again on the time

	#-# Creation of the Table used for copying the files from the database. If missing data, we create a fake name in the column 4 for futur codes
	if(length(STLd_Hours)==0){
	STLd_Hours<-c("0000","0100","0200","0300","0400","0500","0600", "0700", "0800", "0900", "1000", "1100", "1200", "1300", "1400", "1500", "1600", "1700", "1800", "1900", "2000","2100", "2200", "2300")
	} 
	
	Alldays<-c("01","02","03","04","05","06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20","21", "22", "23","24","25","26","27","28")
	TableFinal<-NULL
	cat("Step 2/3. Creating the list of the files available from the database with selected criteria:", sep="\n")
	pb   <- txtProgressBar(1, length(SiteNames), style=3)		
	for(i in 1:length(SiteNames))
		{
		ListSite<-SoundTime[sapply(SoundTime[,4],function(x){strsplit(x,"_")[[1]][1]})==SiteNames[i],]
		Sys.sleep(0.02)
		setTxtProgressBar(pb, i)
		if(nrow(ListSite)==0)
			{
			DatesNfiles_subsample<-paste(substr(sapply(unlist(SoundTime[,4]),function(x){strsplit(x,"_")[[1]][2]})[1],1,6)[[1]],sample(Alldays,STLd_Ndays),sep="")
			}else
			{
			DatesNfiles<-table(sapply(ListSite[,4],function(x){strsplit(x,"_")[[1]][2]}))
			if(length(DatesNfiles)>=STLd_Ndays)
				{
				DatesNfiles_subsample<-names(DatesNfiles[order(DatesNfiles,decreasing=TRUE)][1:STLd_Ndays])
				} 
		
			if(length(DatesNfiles)<STLd_Ndays)
				{
				DatesNfiles_subsample<-c(names(DatesNfiles),paste(substr(names(DatesNfiles)[1],1,6),sample(Alldays[!Alldays%in%substr(names(DatesNfiles),7,8)],STLd_Ndays-length(DatesNfiles)),sep=""))
				}
			}
		
		for (j in 1:length(DatesNfiles_subsample))
			{
			Sub1<-as.matrix(ListSite[substr(sapply(unlist(ListSite[,4]),function(x){strsplit(x,"_")[[1]][2]}),1,8)%in%DatesNfiles_subsample[j]&substr(sapply(unlist(ListSite[,4]),function(x){strsplit(x,"_")[[1]][3]}),1,4)%in%STLd_Hours,])
			HourMissing<-STLd_Hours[!STLd_Hours%in%substr(sapply(unlist(Sub1[,4]),function(x){strsplit(x,"_")[[1]][3]}),1,4)]
			
			if(length(HourMissing)==0)
			{
			TableFinal<-rbind(TableFinal,Sub1)
			}else
			{
			MissingLine<-paste(SiteNames[i],"_",DatesNfiles_subsample[j],"_",HourMissing,"00",sep="")
			Substitute<-t(sapply(MissingLine,function(x){c(rep("NA",3),x,rep("NA",20))}))
			colnames(Substitute)<-colnames(ListSite)
			TableFinal<-rbind(TableFinal,Sub1,Substitute)
			}
			}
		}
		
	#-# Copy the files from Pumilio and organize them in one folder per site AND per Days
	# clean the repertory file.remove(paste(Directory,dir(Directory),sep="/")) TODO
	cat("", sep="\n")
	cat("Step 3/3. Copying and preparing the files from the database to your tmp directory:", sep="\n")
	pb   <- txtProgressBar(1, nrow(TableFinal), style=3)
	TableFinal<-as.data.frame(TableFinal)
	for (i in 1:nrow(TableFinal))
		{
		Sys.sleep(0.02)
		setTxtProgressBar(pb, i)
		if(TableFinal[i,1][[1]]!="NA")
			{
			SiteI<-strsplit(TableFinal[i,4][[1]],"_")[[1]][1]
			dir1<-unlist(strsplit(TableFinal$FilePath[[i]],"/"))[7]
			dir2<-unlist(strsplit(TableFinal$FilePath[[i]],"/"))[8]
			DAY<-strsplit(TableFinal[i,4][[1]],"_")[[1]][2]
			dir.create(paste(Directory,SiteI,sep="/"),showWarnings = FALSE)
			dir.create(paste(Directory,SiteI,DAY,sep="/"),showWarnings = FALSE)
			
			if(length(strsplit(TableFinal[i,4][[1]],".f")[[1]])==2) #it is a flac file
			{
			file.copy(from=paste("Z:/web/soundscape01/pumilio/sounds/sounds/",dir1,"/",dir2,"/",TableFinal[i,4][[1]],sep=""),to=paste(Directory,SiteI,DAY,TableFinal[i,4][[1]],sep="/"))
			wav2flac(paste(Directory,SiteI,DAY,TableFinal[i,4][[1]],sep="/"),reverse=TRUE,overwrite = TRUE,path2exe=pathFlacFronten)
			if(exists('DurationFile')) 
				{
				wav<-readWave(paste(Directory,SiteI,DAY,paste(strsplit(TableFinal[i,4][[1]],".f")[[1]][1],".wav",sep=""),sep="/"),from=0,to=DurationFile,units="seconds")
				writeWave(wav,filename=paste(Directory,SiteI,DAY,paste(strsplit(TableFinal[i,4][[1]],".f")[[1]][1],"_ModifDuration.wav",sep=""),sep="/"))
				file.remove(paste(Directory,SiteI,DAY,paste(strsplit(TableFinal[i,4][[1]],".f")[[1]][1],".wav",sep=""),sep="/"))
				}
			
			} else {
			file.copy(from=paste("Z:/web/soundscape01/pumilio/sounds/sounds/",dir1,"/",dir2,"/",TableFinal[i,4][[1]],sep=""),to=paste(Directory,SiteI,DAY,TableFinal[i,4][[1]],sep="/"))
			if(exists('DurationFile')) 
				{
				wav<-readWave(paste(Directory,SiteI,DAY,TableFinal[i,4][[1]],sep="/"),from=0,to=DurationFile,units="seconds")
				writeWave(wav,filename=paste(Directory,SiteI,DAY,paste(strsplit(TableFinal[i,4][[1]],".w")[[1]][1],"_ModifDuration.wav",sep=""),sep="/"))
				file.remove(paste(Directory,SiteI,DAY,TableFinal[i,4][[1]],sep="/"))
				}
			}
			}

			
		if(TableFinal[i,1][[1]]=="NA")
			{
			SiteI<-strsplit(TableFinal[i,4][[1]],"_")[[1]][1]
			DAY<-strsplit(TableFinal[i,4][[1]],"_")[[1]][2]
			a<-noisew(d=DurationFile+2,f=44100,output="Wave")
			Silence<-cutw(mutew(a, f=44100, from = 1, to = DurationFile+1,units="seconds", plot = FALSE,output = "Wave"),f=44100,from=1,to=DurationFile+1,units="seconds",output="Wave")
			dir.create(paste(Directory,SiteI,sep="/"),showWarnings = FALSE)
			dir.create(paste(Directory,SiteI,DAY,sep="/"),showWarnings = FALSE)
			savewav(Silence,file=paste(Directory,SiteI,DAY,paste(TableFinal[i,4][[1]],"_NASilence",".wav",sep=""),sep="/"))
			}
		}	

	}
}


#END OF THE TIME_LAPSE FILES PREPARATION
###########################################################################################################################################################
