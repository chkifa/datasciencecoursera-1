library(shiny)
library(shinythemes)

# Define user interface for child height prediction application.
shinyUI(fluidPage(theme = shinytheme("cerulean"),
    
    # Application title
    h1("Child's adult height prediction", align="center"),
    br(),br(),

    fluidRow(
        # define the layout such that 2/3 (first 8 columns out of 12 in 
        # a grid setting) of the space on the left is for user input and 
        # 1/3 of the space on the right (the rest 4 colums of the grid)
        # is for output of prediction.
        
        column(8, br(), br(),
            # in the user input space, show a tab set to let user
            # select between US units (feet and inches) and metric
            # units (cm).   
            tabsetPanel(id = "tabs",
                        
                # tab for US units
                tabPanel(title="US Units",value="US_Units",br(),
                    fluidRow(
                        column(11, offset=1,
                            strong(helpText("Mother's height")))), 
                    fluidRow(
                        column(5,offset=1, 
                            sliderInput("mom_height_feet", "feet", 
                                min = 3, max = 7,value = 5)),
                        column(5,
                            sliderInput("mom_height_inches","inches",
                                min = 0, max = 12, value = 4))),
                    fluidRow(
                        column(11, offset=1,
                            strong(helpText("Father's height")))),  
                    fluidRow(
                        column(5, offset=1,
                            sliderInput("dad_height_feet","feet",
                                min = 3,max = 7,value = 5)),
                        column(5,
                            sliderInput("dad_height_inches","inches",
                                min = 0, max = 12, value = 9)))),
                
                # tab for metric units
                tabPanel("Metric Units",value="Metric",br(),br(), br(),
                    fluidRow(
                        column(11, offset=1,
                            sliderInput("mom_height_cm", "Mother's height (cm)",
                                min = 110, max = 220, value = 161))),
                    fluidRow(
                        column(11,offset=1,
                            sliderInput("dad_height_cm", "Father's height (cm)",
                                min = 120,max = 230, value = 175))),
                    br()),
            
            # in user input space, below the tabs, let user select child's 
            # gender between male and female.
            fluidRow(
                column(11, offset=1,
                    radioButtons(inputId="gender", label="Child's gender",
                        choices= c("male" = "male","female" = "female"),
                        selected="female",inline=TRUE)))
        )),
    
    
        #in prediction output space, echo user input and display predicted
        #child height.
        column(4, 
            br(),h3('Results of prediction'),br(),h4('You entered'),

            helpText("Mother's height: "),verbatimTextOutput("mom_height"),
            helpText("Father's height: "),verbatimTextOutput("dad_height"),
            helpText("Child's gender: "),verbatimTextOutput("input_gender"),
            
            h4('Which resulted in a prediction of '),
            verbatimTextOutput("prediction")         
        )
    

)))



