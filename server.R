#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

pacman::p_load(shinyauthr, ggplot2, tidyverse, shiny, sodium)
pacman::p_load_current_gh("hrbrmstr/ggalt")

# login data


# dataframe that holds usernames, passwords and other user data
user_base <- tibble::tibble(
  user = c("stefan", "daniel"),
  password = sapply(c("pass1", "pass2"), sodium::password_store),
  permissions = c("admin", "standard"),
  name = c("stefan", "daniel")
)





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
  
  ############# Login below
  credentials <- shinyauthr::loginServer(
    id = "login",
    data = user_base,
    user_col = user,
    pwd_col = password,
    sodium_hashed = TRUE,
    log_out = reactive(logout_init())
  )
  
  # Logout to hide
  logout_init <- shinyauthr::logoutServer(
    id = "logout",
    active = reactive(credentials()$user_auth)
  )
  ################## Login above
  
    datasetInput <- reactive({
      switch(input$grinder,
             "1zpresso Jx Pro" = zpresso_jx_pro)
      
      
      
    })
    
    dataset_wide_shifted <-  reactive({
      grinder_wide <- datasetInput() 
      
      # account for shift
      shift <- - grinder_wide$setting[grinder_wide$label==input$offset]
      
      #grinder_wide$setting <- grinder_wide$setting + grinder_wide$setting[grinder_wide$label==input$offset]
      assign_l(grinder_wide, shift)
      
      
      
    })
    
    # login UI 
    
    
    output$login_sidebarpanel <- renderUI({
      
      # Show only when authenticated
      req(credentials()$user_auth)
      
      tagList(
        # Sidebar with a slider input
        column(width = 4,
               
               uiOutput("offsetUI")
        ),
        
        column(width = 4,
               p(paste("You have", credentials()$info[["permissions"]],"permission"))
        )
      )
      
    })
    
    
    output$grinder <- renderPlot({
    
      grinder_wide <- dataset_wide_shifted()
      #
      ##grinder_wide <- zpresso_jx_pro
      #
      #
      ## account for shift
      #shift <- - grinder_wide$setting[grinder_wide$label==input$offset]
      #
      ##grinder_wide$setting <- grinder_wide$setting + grinder_wide$setting[grinder_wide$label==input$offset]
      #grinder_wide <- assign_l(grinder_wide, shift)
      
      #offset <- "0-1-1"
      #zpresso_jx_pro$setting +-zpresso_jx_pro$setting[zpresso_jx_pro$label == offset]
      
        grinder_long <- grinder_wide %>% pivot_longer(cols = turkish:french_press, names_to = "type", values_to = "recommended") %>%
        mutate(
          type = factor(type, levels = order)
        )
      
      
        
        
        
    # ggplot(data = grinder_long %>% filter(recommended), aes(x = setting, y = type, color = type)) + 
    #   #geom_line(size = 10, width = 1)  + 
    #   geom_tile(aes(fill = type, color = NULL)) + 
    #   theme_bw() +
    #   theme(legend.position = "bottom") + 
    #   scale_x_continuous(breaks = c(0:10*20),
    #                      labels = grinder_wide$label[c(0:10*20+1)],
    #                      limits = c(min(grinder_wide$setting), max(grinder_wide$setting))) +
    #   geom_vline(xintercept = grinder_wide$setting[grinder_wide$label == input$current_setting])+
    #   geom_vline(xintercept = grinder_wide$setting[grinder_wide$label == input$offset], color = "red")
        
        ## does not quite work yet, problem with shift and displaying all types settings
        plot_data <- grinder_long %>% group_by(type) %>%
          summarize(x = min(which(recommended)),
                    xmax = max(which(recommended)),
                    type = type)
        
        # dumbbell plot
        ggplot(data = plot_data, aes(x = x, xend = xmax, y = type, color = type)) + 
          #geom_line(size = 10, width = 1)  + 
          geom_dumbbell(aes(fill = type)) + 
          theme_bw() +
          theme(legend.position = "bottom") + 
          scale_x_continuous(breaks = c(0:10*20),
                             labels = grinder_wide$label[c(0:10*20+1)],
                             limits = c(min(grinder_wide$setting), max(grinder_wide$setting))) +
          geom_vline(xintercept = grinder_wide$setting[grinder_wide$label == input$current_setting])+
          geom_vline(xintercept = grinder_wide$setting[grinder_wide$label == input$offset], color = "red")
      
    })
    
     output$grinder2 <-  renderPlot({
       
       grinder_wide <- dataset_wide_shifted()
       grinder_long <- grinder_wide %>% pivot_longer(cols = turkish:french_press, names_to = "type", values_to = "recommended") %>%
         mutate(
           type = factor(type, levels = order)
         )
       
       #min(which(grinder$espresso))
       
       ggplot(data = grinder_wide, aes(x = min(which(espresso)), y = "espresso", color = espresso)) + 
         #geom_line(size = 10, width = 1)  + 
     geom_dumbbell(aes(fill = espresso, color = NULL, xend = max(which(espresso)))) + 
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
                         choices = datasetInput()$label,
                        selected = input$offset)
    })
    
    output$offsetUI <- renderUI({
      shiny::selectInput("offset",
                          "Your zero point",
                         choices = datasetInput()$label[startsWith(datasetInput()$label, prefix = "0")],
                         selected = datasetInput()$label[1])
    })
    

})

