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
    
    
    
    ## logout button
    #div(class = "pull-right", shinyauthr::logoutUI(id = "logout")),
    #
    ## login section
    #div(class = "pull-right", shinyauthr::loginUI(id = "login")),
    

    # Sidebar
    sidebarLayout(
        sidebarPanel(
    # Sidebar to show user info after login
          uiOutput("login_sidebarpanel"),
          
          
          selectInput("grinder",
                      "Grinder",
                      choices = c("1zpresso Jx Pro"),
                      selected = "1zpresso Jx Pro"),
          
        
        
          uiOutput("offsetUI"),

          
          uiOutput("currentSettingUI")
        ),
        

        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("grinder"),
            plotOutput("grinder2")
            
        )
    )
))







