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
                      c("1zpresso Jx Pro"),
                      selected = "1zpresso Jx Pro"),
          shiny::numericInput("offset",
                              "Zero point offset on grinder",
                              value = 0,
                              ),
          shiny::numericInput("current_setting",
                              "Current grind setting",
                              value = 40,
          ),
          
            sliderInput("bins",
                        "Number of bins:",
                        min = 1,
                        max = 50,
                        value = 30)
        ),
        

        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("distPlot")
        )
    )
))
