library(shiny)

# Define server logic for child height application
shinyServer(function(input, output) {
    
################################################################################
#    Helper functions   
################################################################################

    # converts height in the form or feet and inches to inches
    # for example, 5 feet 11 inches can be converted by using
    # feet_to_inches(5,11) = 71 to 71 inches.
    feet_to_inches <- function(feet, inches){feet*12 + inches}
    
    # returns predicted child height in cm or inches based on input units.
    # valid input for gender include "male" and "female".
    # valid input for units include "Metric" and "US_Units".
    child_height <- function (gender, units, mom_height, dad_height){
        if (gender == "male" ){ 
            if (units == "Metric"){round((mom_height + dad_height + 13)/2)}
            else{round((mom_height + dad_height + 5)/2)}
        }else{ 
            if (units == "Metric"){round((mom_height + dad_height - 13)/2)}
            else{round((mom_height + dad_height - 5)/2)}}      
    }
    
    # returns string representation of input height in cm or feet and inches.
    # valid input for height_units include "Metric" and "US_Units".
    # valid input for height is the numeric value of height in cm or inches,
    # depending on height_units.
    # for example, output_height_text("Metric", 173) = "173 cm", 
    # output_height_text("US_Units", 65) = "5 feet 5 inches" and 
    # output_height_text("US_Units", 73) = "6 feet 1 inch".
    output_height_text <- function (height_units, height){
        answer <- ifelse(height_units == "Metric",
               paste(height, " cm",sep=""),
               paste(height%/%12," feet ", height%%12," inch",sep=""))
        #plurals of inch is innches
        if (height_units == "US_Units" & height%%12 > 1){
            answer <- paste(answer, "es", sep="")}
        answer
    }
    
###############################################################################
#   Reactive expressions to be used in rederText statements
############################################################################### 

    # returns input mother's height in inches or cm depending on 
    # if the user selects the "US Units" tab or "Metric Units" tab.
    input_mom_height <- reactive(
        {ifelse(input$tabs=="Metric",input$mom_height_cm, 
            feet_to_inches(input$mom_height_feet,input$mom_height_inches))}) 
    
    # retruns string representation of input mother's height to be 
    # displayed back to the user.
    input_mom_height_text <- reactive(
        {output_height_text(input$tabs,input_mom_height())})

    # returns input father's height in inches or cm depending on 
    # if the user selects the "US Units" tab or "Metric Units" tab.    
    input_dad_height <- reactive(
        {ifelse(input$tabs=="Metric",input$dad_height_cm, 
            feet_to_inches(input$dad_height_feet,input$dad_height_inches))})

    # retruns string representation of input father's height to be 
    # displayed back to the user.    
    input_dad_height_text <- reactive(
        {output_height_text(input$tabs,input_dad_height())})

    #returns predicted child height in inches or cm depending on 
    # if the user selects the "US Units" tab or "Metric Units" tab.
    predicted_child_height <- reactive(
        {child_height(input$gender, input$tabs,
            input_mom_height(), input_dad_height())}) 

    # retruns string representation of predicted child height to be 
    # displayed back to the user.    
    prediction_text <- reactive(
        {output_height_text(input$tabs,predicted_child_height())}) 
    
###############################################################################
#   Output values to be displayed in user interface
############################################################################### 

    output$input_gender <- renderText({input$gender}) 
    output$mom_height <- renderText({input_mom_height_text()})
    output$dad_height <- renderText({input_dad_height_text()})
    output$prediction <-  renderText({prediction_text()})
    
        
})
