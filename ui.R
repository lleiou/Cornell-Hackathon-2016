library("shiny")

shinyUI(fluidPage(
  
  fluidRow(
    column(12,
           #titlePanel(strong("TripAid"), windowTitle="TripAid"),offset=1),
           img(src = "r.jpg", height = 85, width = 300),offset=9),
    
    
    column(4,
           radioButtons("language", label = "Language", 
                        choices = list("English" = 1, "Chinese"= 2, "Spanish"=3), 
                        selected = 1,inline = TRUE) )),
    
    sidebarLayout(
      sidebarPanel(
        textInput("Caption", HTML(" <h6>Where are you located?</h6>"), "5 Times Square, New York, NY"),
        radioButtons("Er", label = "Emergency",
                     choices = list("Yes" = 0, "No" = 1),selected = 1),
        
        selectInput("In", 
                    label = "Insurance",
                    choices = c("I don't care", "No",
                                "Aetna", "Travelx Insurance Service"),
                    selected = "I don't care"),
        
        selectInput("Diag", 
                    label = "Diagnosis Description",
                    choices = c("Search...","Alcohol/Drug Disorders", "Burns",
                                "Circulatory Sys Diseases", "Digestive Sys Diseases","Kidney & Urinary Tract Diseases ","Muscular/Bone Diseases", "Respiratory Sys Diseases
                                ", "Eye, Ear, Nose, Mouth, Throat Disorders","Infectious and Parasitic Diseases","Mental Diseasess"),
                    selected = "Search..."),
        
        sliderInput("range", 
                    label = "Average Cost:",
                    min = 0, max = 100, value = c(0, 100)),
        sliderInput("range2",
                    label="Wait Time:",
                    min=0, max=100, value=c(0,100)),
        sliderInput("range3",
                    label="Satisfaction Rate:",
                    min=0,max=100, value=c(0,100)),
        
        sliderInput("range4",
                    label="Number of Cases:",
                    min=0, max=100,value=c(0,100))
        
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
                 plotOutput("histogram")),
        tabPanel('About TripAid', HTML("
                                   <h4>
                                       What is TripAid
                                       </h4>
                                       <p>
                                       This web application, developed in spring 2016 at Cornell Tech, is mainly for NYC travelers who come to NYC for the first time. It's also very helpful for native residents who are not familiar with New York's medical sytem and need direct guidance to find the best hospital in NYC. Therefore, it also has several language versions.
                                       </p>
                                       <h4>
                                       Hightlight of TripAid
                                       </h4>
                                       <p>
                                       In general, the application is an HCI product developed in R studio with Shiny. The hightlight of this product is its ability to provide users the comprehensive ranking of all NYC hospitals given their health emergency and insurance status. 
                                       </p>
                                       <br/>
                                       <p>
                                       To be more specific, the features of our interest include how far awary the hospital is from the user, total expense, waiting time for an ER, historical diseases cases and number of days in hospital. 
                                       </P>
                                       <br/>
                                       <p>
                                       To make user experience much better, especially for those in emergence status, we set all settings suitable for them in default. This enables them to find the nearest as well as the top ranking hospitals in much shorter time. 
                                       </p>
                                       <br/>
                                       <p>
                                       Users could see the result in a module with google map, which shows thier location and suggests hospitals at the same time. 
                                       </p>
                                       <h4>
                                       Future Expectations
                                       </h4>
                                       <p>
                                       We are also looking forward to develop a similar iOS/Android app, which is more user friendly.
                                       </p>
                                       
                                       ")),
        
        tabPanel('Get to Know US', HTML("
                                        <h4>   About Us!  </h4>
                                        <p>
                                        We are all Master students from Statistics Department of Columbia University, expected to graduate at Dec. 2016.
                                        </p>
                                        
                                        <h4>   Team Members </h4>
                                        <p>
                                        Aoyuan Liao, Jingwei Li, Wen Ren, Yanran Wang, Ao liu, Duanhong Gao. 
                                        </p>
                                        <br/>
                                        <p>
                                        For questions or feedback, please email <a href='mailto:al3468@columbia.edu'>al3468@columbia.edu</a>.
                                        </p>
                                        "
                                        
        ))
                                       
                                       
                    ))
                   ))
                                       
                                       
                                       
    )
                                       
                                       
                                       