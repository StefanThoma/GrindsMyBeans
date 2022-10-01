#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(


    # Application title
    titlePanel("Grind My Beans"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
          selectInput("grinder",
                      "Grinder",
                      choices = c("1zpresso Jx Pro"),
                      selected = "1zpresso Jx Pro"),
          
        
        
          shiny::uiOutput("offsetUI"),

          
          shiny::uiOutput("currentSettingUI")
        ),
        

        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("grinder"),
            plotOutput("grinder2")
            
        )
    )
))







