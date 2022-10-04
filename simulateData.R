# setting used by ST
setting_ST <- "1-5-3"

# get helping function
source("create_grinders.R")

# read data
#extend_range <- 2
grinder <- assign_l(zpresso_jx_pro, shift = 0) 

# get range of reasonable espresso settings
espresso_range <- grinder$setting[grinder$espresso]
espresso_range <- range(espresso_range) + c(-diff(range(espresso_range)), diff(range(espresso_range)))
espresso_range <- seq(from = espresso_range[1], to = espresso_range[2])

grinder$setting[grinder$label==setting_ST]

#' generative model
#'
#' @param sweetspot 
#' @param brand 
#' @param coffee_type 
#'
#' @return
generative_model <- function(sweetspot, brand, coffee_type){
  
  prior <- brms::set_prior(prior = "normal(0,10)",class = "b", coef = "poly(setting, 1)")
  #
  #?brms::set_prior
  prior <- brms::get_prior(formula = time~1 + poly(setting, 2), data = data)
  
  
  library(brms)
  prior <-c(set_prior("normal(0, 2)", class = "b"), set_prior("student_t(3,1,2.5)", class = "Intercept"))
  sim <- brms::brm(sample_prior = "only", formula = time ~ poly(setting, 2), prior = prior, data = data)
  
  
  
  # sample(sim)
  poly(1:10, 3)
  x <- sample(1:100 / 5, 20)
  
  # parameters
  intercept <- 5
  b1 <- .5
  b2 <- .002
  b3 <- .1
  b4 <- .002
  
  # simulate one coffee extraction
  sim_data <- data.frame(time = intercept + b1*x + b2*x^2 + b3*x^3 + b4*x^4 + rnorm(length(x)),
                         setting = x)
    approx(y = sim_data$setting, x = sim_data$time, xout = 27)$y
}

data <- data.frame(time = 1, setting = 0:100)


example_data <- data.frame(setting = 21:30, time = c(60, 60, 60, 50, 40, 30, 20, 10, 10, 10))
plot(example_data, time ~ setting)

obj <- lm(time ~ poly(setting, 1), data = example_data)

curve(predict(obj, newdata = data.frame("setting" = x)), from = 0, to = 100)
plot(obj) 

predict(obj, newdata = data.frame("setting" = 1:100))

## something like this, maybe with simulated data:
approx(x = obj$fitted.values, y = example_data$setting, xout = 27)

#' create_coffee_machine
#' creates a coffee_machine, which is a function that creates coffee.
#' "coffee" in that sense is the output time, depending on input grind level.
#'
#' @param brand type of coffee machine, just a random parameter
#' @param sweetspot grind setting that on average should lead to 27s extraction time
#' @return function which creates time for coffee
#'
#' @examples
create_coffee_machine <- function(brand, sweetspot){
  brand_effect <- rnorm(1)
  
  function(coffee_type, coffee_amount = NULL, setting){
    print(brand)
    
    time <- 20
    time
  }
}


pavoni <- create_coffee_machine("PAVONI", 15)
pavoni("dark", setting = 15)



