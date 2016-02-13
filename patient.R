setwd("C:/Original/good stat/Data Hackathon")
library("dplyr")
library("data.table")
library("ggplot2")
library("choroplethr")

reRead <- 1
##read data and save it as RData to save time nect time:
if(reRead==1){
  colsToKeep <- c("Health Service Area")
  Data <- fread("Hospital_Inpatient_Discharges__SPARCS_De-Identified___2012.csv", select=colsToKeep )  
  save(Data, file="rawData.RData")
}else{
  load("rawData.RData")
} 

data<-tbl_df(Data)
dm<-na.omit(data)%>%
    group_by(`Health Service Area`)%>%
     summarise(freq=n())
