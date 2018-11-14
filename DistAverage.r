## Code to average a distance matrix, based on a know factor##
## Case of use: you want to reduce a pair-wise matrix of Df acoustic diversity indices by averaging on the "hour" (average similar hours), on the "sites" (average similar Sites) or on the days (average similar days)##
## Author: Amandine Gasc, version 20181008, amandine.gasc@ird.fr
## First used in the Scientific paper : Gasc, A., Sueur, J., Pavoine, S., Pellens, R., & Grandcolas, P. (2013). Biodiversity Sampling Using a Global Acoustic Approach: Contrasting Sites with Microendemics in New Caledonia. PLoS ONE, 8(5), e65311. https://doi.org/10.1371/journal.pone.0065311

# Argument of the functions:
# mat is of class matrix and need to be an euclidean distance matrix
# factor_Site of the length of the column or row of the matrix
# factor_Day of the length of the column or row of the matrix
# factor_Hour of the length of the column or row of the matrix
# FactorToAverage can be "factor_Site", "factor_Day" or"factor_Hour"
# RemoveNA can be "TRUE" or "FALSE", in case it is TRUE and if there are some NA in the final averaged matrix, a function will remove the NA value by a step by step method in order to remove the less data possible.


DistAverage<-function(mat,factor_Site,factor_Day,factor_Hour,FactorToAverage,RemoveNA=TRUE)
{
require('stringr')


#...names
	if (FactorToAverage=="factor_Site")
	{
	FactorToAverage1=factor_Site
	dimMat<-length (unique(factor_Day))* length(unique(factor_Hour))
	}


	if (FactorToAverage=="factor_Day")
	{
	FactorToAverage1=factor_Day
	dimMat<-length (unique(factor_Site))* length(unique(factor_Hour))
	}

	if (FactorToAverage=="factor_Hour")
	{
	FactorToAverage1=factor_Hour
	dimMat<-length (unique(factor_Day))* length(unique(factor_Site))
	}


#...Function to create a list of matrices for each day from the original Matrix
	fun0 <- function(mat)
	{
	listparjour <- lapply(unique(FactorToAverage1), function(x) mat[FactorToAverage1==x, FactorToAverage1 == x])
	return(listparjour)
	}
	
	List_Mat <- fun0(as.matrix(mat))
	

#....The matrices has to be similar in dimension. it happen if your example you have missing hours of recording for some days. Remove the days for the original analyses.
	if(length(unique(lapply(List_Mat, dim)))!=1) 
	{
		stop("dimention of your matrices are not equal")
	}

#...Average step

	#From matrices to vector
	List_vec <- lapply(List_Mat, as.vector)

	#We make a Table with the factor to average in column
	List_vec2 <- cbind.data.frame(List_vec)
	colnames(List_vec2)<-seq(1,ncol(List_vec2),1)

	#Average
	List_vec2M <- apply(List_vec2, 1, mean, na.rm = T)

	#From vector back to matrix
	matAveraged <- matrix(List_vec2M, dimMat,dimMat) 
	if (length(unique(unlist(lapply(strsplit(rownames(List_Mat[[1]]),"_"),function(x){x[1]}))))==1)
	{
		rownames(matAveraged)<-colnames(matAveraged)<-paste(unlist(lapply(strsplit(rownames(List_Mat[[1]]),"_"),function(x){x[2]})),unlist(lapply(strsplit(rownames(List_Mat[[1]]),"_"),function(x){x[3]})),sep="_")
	}
	
	if (length(unique(unlist(lapply(strsplit(rownames(List_Mat[[1]]),"_"),function(x){x[2]}))))==1)
	{
		rownames(matAveraged)<-colnames(matAveraged)<-paste(unlist(lapply(strsplit(rownames(List_Mat[[1]]),"_"),function(x){x[1]})),unlist(lapply(strsplit(rownames(List_Mat[[1]]),"_"),function(x){x[3]})),sep="_")
	}
	
	if (length(unique(unlist(lapply(strsplit(rownames(List_Mat[[1]]),"_"),function(x){x[3]}))))==1)
	{
		rownames(matAveraged)<-colnames(matAveraged)<-paste(unlist(lapply(strsplit(rownames(List_Mat[[1]]),"_"),function(x){x[1]})),unlist(lapply(strsplit(rownames(List_Mat[[1]]),"_"),function(x){x[2]})),sep="_")
	}


#...Removal of NA step by step
	if (any(is.na(matAveraged))&&RemoveNA==TRUE)  
	{
		cat("Some NA has been found, the code will remove the NA before to return the averaged matrix" )
	
		while(length(unique(col(matAveraged)[is.na(matAveraged)]))!=0)
	{
		NumberNARow<-NULL
		for( i in 1: nrow(matAveraged))
		{
			VecRow<-matAveraged[i,]
			NumberNARow[i]<-length(VecRow[is.na(VecRow)])
		}
		NumberNARow<-as.data.frame(NumberNARow)
		NumberNARow[,2]<-rownames(matAveraged)
		NumberNARowO<-NumberNARow[order(NumberNARow[,1],decreasing=TRUE),]

		NumberNAColumn<-NULL
		for( i in 1: nrow(matAveraged))
		{
			 veccol<-matAveraged[i,]
			 NumberNAColumn[i]<-length(veccol[is.na(veccol)])
		}
		NumberNAColumn<-as.data.frame(NumberNAColumn)
		NumberNAColumn[,2]<-colnames(matAveraged)
		NumberNAColumnO<-NumberNAColumn[order(NumberNAColumn[,1],decreasing=TRUE),]

		if(NumberNAColumn[1,1]>=NumberNARow[1,1])
		{
			matAveraged<-matAveraged[colnames(matAveraged)!=NumberNAColumnO[1,2],colnames(matAveraged)!=NumberNAColumnO[1,2]]} else{matAveraged<-matAveraged[colnames(matAveraged)!=NumberNARowO[1,2],colnames(matAveraged)!=NumberNARowO[1,2]]}
		}

		return(matAveraged)
	
	} else 	{
	return (matAveraged)
	}
	
 }
 
# # example 1 without NA
# vec<-sample(seq(from=0.11,to=0.99,by=0.01), 36*36, replace = TRUE, prob = NULL)
# mat<-as.matrix(as.dist(matrix(vec, 36, 36)))
# colnames(mat)<-rownames(mat)<-c(paste(rep("site1",12),c(rep("day1",4),rep("day2",4),rep("day3",4)),c("h1","h2","h3","h4"),sep="_"),
# paste(rep("site2",12),c(rep("day1",4),rep("day2",4),rep("day3",4)),c("h1","h2","h3","h4"),sep="_"),
# paste(rep("site3",12),c(rep("day1",4),rep("day2",4),rep("day3",4)),c("h1","h2","h3","h4"),sep="_"))
# MatrixAveraged<-DistAverage(mat=mat,factor_Site=substr(colnames(mat),1,5),factor_Day=substr(colnames(mat),7,10),factor_Hour=substr(colnames(mat),12,13),FactorToAverage="factor_Hour",RemoveNA=TRUE)


# # example 2 with NA
# vec<-sample(seq(from=0.11,to=0.99,by=0.01), 36*36, replace = TRUE, prob = NULL)
# vec[c(5:145,1200:1250)]<-NA
# mat<-as.matrix(as.dist(matrix(vec, 36, 36)))
# colnames(mat)<-rownames(mat)<-c(paste(rep("site1",12),c(rep("day1",4),rep("day2",4),rep("day3",4)),c("h1","h2","h3","h4"),sep="_"),
# paste(rep("site2",12),c(rep("day1",4),rep("day2",4),rep("day3",4)),c("h1","h2","h3","h4"),sep="_"),
# paste(rep("site3",12),c(rep("day1",4),rep("day2",4),rep("day3",4)),c("h1","h2","h3","h4"),sep="_"))
# MatrixAveraged<-DistAverage(mat=mat,factor_Site=substr(colnames(mat),1,5),factor_Day=substr(colnames(mat),7,10),factor_Hour=substr(colnames(mat),12,13),FactorToAverage="factor_Hour",RemoveNA=TRUE)

