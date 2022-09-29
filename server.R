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
zpresso_jx_pro <- read.csv("grinders/zpresso_jx_pro.csv") %>%
  mutate(label2 = ifelse(endsWith(label, "0"), label, ""))
order <- c("turkish", "espresso", "aeropress", "moka_pot", "drip_coffee_maker", "siphon", "pour_over", "french_press")  

zpresso_ticks <- paste(rep(0:4, each = 10), rep(0:9, times =5), "0", sep = "-")
zpresso_size <- rep(c(1, rep(0, times = 9)), times = 5)

## helping function for offset
# get a logical vector indicating which settings are inbetween the limits based on labels.
get_l <- function(data, limits, shift = 0){
  data$setting + shift >= data$setting[data$label == limits[1]]  & 
    data$setting  + shift <= data$setting[data$label == limits[2]]
}


assign_l <- function(data, shift = 0){
  
  turkish <- get_l(data = data, limits = c("0-8-0", "1-2-0"), shift = shift)
  espresso <- get_l(data = data, limits = c("1-2-0", "1-6-0"), shift = shift)
  aeropress <- moka_pot <- drip_coffee_maker <- get_l(data = data, limits = c("2-4-0", "3-0-0"), shift = shift)
  siphon <- pour_over <-  get_l(data = data, limits = c("3-2-0", "4-4-0"), shift = shift)
  french_press <- get_l(data = data, limits = c("4-2-0", "5-0-0"), shift = shift)
  
  cbind(data[c(1,2)], 
        turkish,
        espresso,
        aeropress,
        moka_pot,
        drip_coffee_maker,
        siphon,
        pour_over,
        french_press
  )
}









# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    datasetInput <- reactive({
      switch(input$grinder,
             "1zpresso Jx Pro" = zpresso_jx_pro)
    })
    
    
    
    
    output$grinder <- renderPlot({
    
      grinder_wide <- datasetInput() 
      
      #grinder_wide <- zpresso_jx_pro
      
      
      # account for shift
      shift <- -grinder_wide$setting[grinder_wide$label==input$offset]
      
      #grinder_wide$setting <- grinder_wide$setting + grinder_wide$setting[grinder_wide$label==input$offset]
      grinder_wide <- assign_l(grinder_wide, shift)
      
      #offset <- "0-1-1"
      #zpresso_jx_pro$setting +-zpresso_jx_pro$setting[zpresso_jx_pro$label == offset]
      
        grinder_long <- grinder_wide %>% pivot_longer(cols = turkish:french_press, names_to = "type", values_to = "recommended") %>%
        mutate(
          type = factor(type, levels = order)
        )
      
        
        
        
      ggplot(data = grinder_long %>% filter(recommended), aes(x = setting, y = type, color = type)) + 
        geom_line(size = 10, width = 1)  + 
        theme_bw() +
        theme(legend.position = "bottom") + 
        scale_x_continuous(breaks = c(0:10*20),
                           labels = grinder_wide$label[c(0:10*20+1)],
                           limits = c(min(grinder_wide$setting), max(grinder_wide$setting))) +
        geom_vline(xintercept = grinder_wide$setting[grinder_wide$label == input$current_setting])+
        geom_vline(xintercept = grinder_wide$setting[grinder_wide$label == input$offset], color = "red")
      
      
    })
    
    output$currentSettingUI <- renderUI({
      shiny::selectInput("current_setting",
                         "Current grind setting",
                         choices = datasetInput()$label)
    })
    
    output$offsetUI <- renderUI({
      shiny::selectInput("offset",
                          "Your zero point",
                         choices = datasetInput()$label[startsWith(datasetInput()$label, prefix = "0")],
                         selected = datasetInput()$label[1])
    })
    

})


#zeropoint <- "0-5-0"
#
#ggplot(data = data %>% filter(recommended), aes(x = setting, y = type, color = type)) + 
#    geom_line(size = 10)  + 
#    theme_bw() +
#    xlim(-1, 201) +
#    theme(legend.position = "bottom") + 
#    scale_x_continuous(breaks = c(0:10*20+1),
#                       labels = zpresso_jx_pro$label[c(0:10*20+1)])
