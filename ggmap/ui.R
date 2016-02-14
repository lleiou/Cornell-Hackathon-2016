setwd("C:/Users/Eve/Documents/crime_map/ggmap")
library(shiny)

shinyUI(fluidPage(
  sidebarLayout(
    sidebarPanel(width = 3,
    textInput("address", HTML(" <h6>Where are you located?</h6>"), "5 Times Square, New York, NY")),
    mainPanel(
      tabPanel('Address',textOutput("address")),
      tabPanel('Map',htmlOutput("map")),
      tabPanel('Distance'),textOutput("distance"))
)))