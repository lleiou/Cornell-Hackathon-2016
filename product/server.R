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

addDistance<- function(data,address){
  hos<- as.matrix(data$`Facility Name`);
  
  Distance<- as.data.frame(matrix(0,length(hos),1)); colnames(Distance)<- 'Distance';
  partialdata<- cbind(data,Distance);   partialdata<- as.data.frame(data);
  
  for(i in 1:length(hos))  
  {
    partialdata[i,'Distance'] = round(mapdist(paste(hos[i], ", NY", sep = ""),
                                              address, mode = 'driving')$miles,2);
  }
  return(partialdata);
}
add<-function(partialdata,CostWeight,TimeWeight,DistanceWeight,SaWeight,DiagWeight){
  partialdata<-mutate(partialdata,total=num_case*DiagWeight+Distance*DistanceWeight+fee*CostWeight,satis*SaWeight+waitime*TimeWeight)
  return(partialdata);
}

shinyServer( function(input, output) {
  CostWeight=1
  TimeWeight=1
  DistanceWeight=1
  SaWeight=1
  DiagWeight=1
  # output$data<-renderText({input$In})
  general<-reactive({
    dd<-hosp
    if (input$Er==1) {
      flag=1
      partialdata<-dd
      }
    else if (input$In=="I don't care" | input$In=="No") {
      flag=0
      Data <- dd %>%
        filter(`APR MDC Description` == as.character(input$Diag)) %>%
        group_by(`Facility Name`) 
      rd<- Data %>%
        summarise(count = n())%>%
        mutate(number_case=count)
      pay<-Data %>%
        summarise(charge = mean(`Total Charges`))
      rd$fee<-pay$charge
      
    }else {  flag=0 
      Data <- dd %>%
          filter(`APR MDC Description` == as.charactor(input$Diag)) %>%
          group_by(`Facility Name`) 
      rd<- Data %>%
        summarise(count = n())%>%
        mutate(num_case=count)
      pay<-Data %>%
        summarise(charge = mean(`Total Charges`))
      rd$fee<-pay$charge
    }  ##add insurance list
    address<-as.character(input$Caption)
    if (flag==0){
      partialdata<-rd
      partialdata<-partialdata[!duplicated(partialdata$`Facility Name`),]
      partialdata<-mutate(partialdata,waitime=hosp2[which(partialdata$`Facility Name`== hosp2$`Facility Name`),3])
      partialdata<-mutate(partialdata,satis=hosp2[which(partialdata$`Facility Name`== hosp2$`Facility Name`),2])
      partialdata<-addDistance(partialdata,address)
      partialdata<-add(partialdata,CostWeight,TimeWeight,DistanceWeight,SaWeight,DiagWeight);
      
    } else {
   
      partialdata<-partialdata[!duplicated(partialdata$`Facility Name`),]
      partialdata<-mutate(partialdata,waitime=hosp2[which(partialdata$`Facility Name`== hosp2$`Facility Name`),3])
      partialdata<-mutate(partialdata,satis=hosp2[which(partialdata$`Facility Name`== hosp2$`Facility Name`),2])
      partialdata<-addDistance(partialdata,address)
      partialdata<-mutate(partialdata,total=-Distance)
    }
    partialdata
    })
  
  output$List<-renderDataTable({
    partialdata<-general();
    data<-as.data.frame(partialdata)
    data<-data[sort(data$total, decreasing=TRUE, index.return=TRUE)$ix,];
    data<- cbind(1:nrow(data), data); data<-data[1:10,]
    data
  })
})