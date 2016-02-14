library("shiny")

shinyUI(fluidPage(
  
  fluidRow(
    column(12,
           titlePanel(strong("TripAid"), windowTitle="TripAid"),offset=1),
    
    
    
    column(12,
           radioButtons("language", label = "Language", 
                        choices = list("English" = 1, "Chinese"= 2, "Spanish"=3), 
                        selected = 1,inline = TRUE) ,offset=8),
    
    sidebarLayout(
      sidebarPanel(
        textInput("Caption", HTML(" <h6>Where are you located?</h6>"), "5 Times Square, New York, NY"),
        radioButtons("Er", label = "Emergency",
                     choices = list("Yes" = 0, "No" = 1),selected = 0),
        
        selectInput("In", 
                    label = "Insurance",
                    choices = c("I don't care", "No",
                                "Percent Hispanic", "Percent Asian"),
                    selected = "I don't care"),
        
        selectInput("Diag", 
                    label = "Diagnosis Description",
                    choices = c("Search...","Alcohol/Drug Disorders", "Burns",
                                "Circulatory Sys Diseases", "Digestive Sys Diseases","Kidney & Urinary Tract Diseases ","Muscular/Bone Diseases", "Respiratory Sys Diseases
                                ", "Eye, Ear, Nose, Mouth, Throat Disorders","Infectious and Parasitic Diseases","Mental Diseasess"),
                    selected = "Search..."),
        
        sliderInput("range", 
                    label = "Range of interest:",
                    min = 0, max = 100, value = c(0, 100))
        ),
    
    mainPanel(
      
      tabsetPanel(
        tabPanel('List',
                 dataTableOutput(outputId="List"),
                 tags$style(type="text/css", '#myTable tfoot {display:none;}')),
        tabPanel('Map',
                 htmlOutput("mapped")),
        tabPanel('Radar Plot',
                 textOutput("data")),
        
        tabPanel('Critical Features',
                 plotOutput("histogram"))
        
                                       
                                       
                    ))
                   ))
                                       
                                       
                                       
    )) 
                                       
                                       
                                       