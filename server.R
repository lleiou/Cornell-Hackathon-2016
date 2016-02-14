library("dplyr")
library("data.table")
library("stringr")
library("muStat")
library(data.table)
library(shiny)
library(data.table)
library(googleVis)
library(ggplot2)
library(ggmap)
library(RCurl)

suppressPackageStartupMessages(library(googleVis));
load("hosp.RData")
load("hosp2.RData")


addDistance<- function(partialdata,address){
  hos<- as.matrix(partialdata$name);
  
  Distance<- as.data.frame(matrix(0,length(hos),1)); colnames(Distance)<- 'Distance';
  partialdata<- cbind(partialdata,Distance);   partialdata<- as.data.frame(partialdata);
  
  for(i in 1:length(hos))  
  {
    partialdata[i,'Distance'] = round(mapdist(paste(hos[i], ", NY", sep = ""),
                                              address, mode = 'driving')$miles,2);
  }
  return(partialdata);
}
add<-function(partialdata,CostWeight,TimeWeight,DistanceWeight,SaWeight,DiagWeight){
  partialdata<-mutate(partialdata,total=cases*DiagWeight+Distance*DistanceWeight+charge*CostWeight,recom*SaWeight+wait*TimeWeight)
  return(partialdata);
}

shinyServer( function(input, output) {
  CostWeight=1
  TimeWeight=1
  DistanceWeight=1
  SaWeight=1
  DiagWeight=1
general<-reactive({
  
  
  dd<-hosp
  if (input$Er==1) {
    flag=1
    partialdata<-dd
    colnames(partialdata)[1]<-"name"
  }else if (input$In=="I don't care" | input$In=="No") {
    flag=0
    Data <- dd %>%
      filter(`APR MDC Description` == as.character(input$Diag)) %>%
      group_by(`Facility Name`) 
    rd<- Data %>%
      summarise(count = n())
    case <- data.frame(name = rd$`Facility Name`, cases = rd$count) 
    pay<-Data %>%
      summarise(charge = mean(`Total Charges`))
    charge <- data.frame(name = pay$`Facility Name`, charge =pay$charge)
    
  }else {  flag=0 
  Data <- dd %>%
    filter(`APR MDC Description` == as.charactor(input$Diag)) %>%
    group_by(`Facility Name`) 
  rd<- Data %>%
    summarise(count = n())
  case <- data.frame(name = rd$`Facility Name`, cases = rd$count) 
  pay<-Data %>%
    summarise(charge = mean(`Total Charges`))
  charge <- data.frame(name = pay$`Facility Name`, charge =pay$charge)
  }  ##add insurance list
  address<-as.character(input$Caption)
  if (flag==1){
    partialdata<-partialdata[!duplicated(partialdata$name),]
    partialdata<-mutate(partialdata,wait=hosp2[which(partialdata$name== hosp2$`Facility Name`),`Waiting Time`])
    partialdata<-mutate(partialdata,recom=hosp2[which(partialdata$name== hosp2$`Facility Name`),`Recommend Hospital`])
    partialdata<-addDistance(partialdata,address)
    partialdata<-mutate(partialdata,total=-Distance)
    
    
  } else {
    
    partialdata<-merge(case, charge, all = TRUE, by = intersect(names(case), names(charge)))
    recom <- data.frame(name = hosp2$`Facility Name`, recom = hosp2$`Recommend Hospital`)
    wait <- data.frame(name = hosp2$`Facility Name`, wait = hosp2$`Waiting Time`)
    partialdata<- merge(partialdata, recom, all = TRUE, by = intersect(names(partialdata), names(recom)))
    partialdata <- merge(partialdata, wait, all = TRUE, by = intersect(names(partialdata), names(wait)))
    partialdata <-na.omit(partialdata)
    partialdata<-addDistance(partialdata,address)
    partialdata<-add(partialdata,CostWeight,TimeWeight,DistanceWeight,SaWeight,DiagWeight);
    
  }
  partialdata<-na.omit(partialdata)
  data<-as.data.frame(partialdata)
    data
    })
  
  output$List<-renderDataTable({
    partialdata<-general();
    data<-as.data.frame(partialdata)
    data<-data[sort(data$total, decreasing=TRUE, index.return=TRUE)$ix,];
    data<- cbind(1:nrow(data), data); data<-data[1:10,]
    data
  })
  
  output$mapped <- renderGvis({   
    partialdata<- general();
    data<- partialdata[sort(partialdata$total, decreasing=TRUE, index.return=TRUE)$ix,];
    data<- data[1:10,]; 
    data$name<- paste(unique(data$name), ", New York, NY", sep = "");
    ranks<-paste(1:10,". ", sep="");
    data$name<- paste(ranks, data$name, sep = "");
    #print(data$Hospital)
    gvisMap(data, "name" , c("name"), 
            options=list(showTip=TRUE, 
                         showLine=TRUE, 
                         enableScrollWheel=TRUE,
                         mapType='normal', 
                         useMapTypeControl=TRUE))
    
  })
})