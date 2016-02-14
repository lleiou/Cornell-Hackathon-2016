library(shiny)
library(data.table)
library(googleVis)
library(ggplot2)
library(ggmap)
library(RCurl)
suppressPackageStartupMessages(library(googleVis));


shinyServer(function(input, output) { 
output$map<- renderGvis({   
  #print(data$Hospital)
  d<-data.frame(cbind(as.character(input$address),"1"))
  colnames(d)<-c("Hospital","Rank")
  gvisMap(d, "Hospital" , c("Rank"), 
          options=list(showTip=TRUE, 
                       showLine=TRUE, 
                       enableScrollWheel=TRUE,
                       mapType='normal', 
                       useMapTypeControl=TRUE))
  
 })
  output$distance<- renderText({
     b<-round(mapdist("10025",as.character(input$address),mode='driving')$miles,2)
     as.character(b)
})
})