#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#


library(shiny)
library(tidyverse)
library(ggplot2)

# read data

  # read data
#zpresso_jx_pro <- read.csv("1zpresso_jx_pro.csv")
  

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

  
    output$distPlot <- renderPlot({

        # generate bins based on input$bins from ui.R
        x    <- faithful[, 2]
        bins <- seq(min(x), max(x), length.out = input$bins + 1)

        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = 'darkgray', border = 'white',
             xlab = 'Waiting time to next eruption (in mins)',
             main = 'Histogram of waiting times')

    })
    
    #if(input$grinder == "1zpresso Jx Pro"){
    #  grinder_data <- zpresso_jx_pro
    #}
    
    #output$grinder <- renderPlot({
    #  #ggplot()
    #  
    #  
    #})

})
