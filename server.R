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
zpresso_jx_pro <- read.csv("grinders/zpresso_jx_pro.csv")
order <- c("turkish", "espresso", "aeropress", "moka_pot", "drip_coffee_maker", "siphon", "pour_over", "french_press")  

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
    
    datasetInput <- reactive({
      switch(input$grinder,
             "1zpresso Jx Pro" = zpresso_jx_pro)
    })
    
    
    output$grinder <- renderPlot({
      data <- datasetInput() %>% pivot_longer(cols = turkish:french_press, names_to = "type", values_to = "recommended") %>%
        mutate(
          type = factor(type, levels = order)
        )
      
      ggplot(data = data %>% filter(recommended), aes(x = setting, y = type, color = type)) + 
        geom_line(position = "dodge", size = 10)  + 
        theme_bw() +
        theme(legend.position = "bottom") + 
        scale_x_continuous(breaks = c(0:10*20+1),
                           labels = datasetInput()$label[c(0:10*20+1)],
                           limits = c(0,201)) +
        geom_vline(xintercept = datasetInput()$setting[datasetInput()$label == input$current_setting])
      
      
    })
    
    output$currentSettingUI <- renderUI({
      shiny::selectInput("current_setting",
                         "Current grind setting",
                         choices = datasetInput()$label)
    })

})


#ggplot(data = data %>% filter(recommended), aes(x = setting, y = type, color = type)) + 
#    geom_line(position = "dodge", size = 10)  + 
#    theme_bw() +
#    xlim(-1, 201) +
#    theme(legend.position = "bottom") + 
#    scale_x_continuous(breaks = c(0:10*20+1),
#                       labels = zpresso_jx_pro$label[c(0:10*20+1)])
#