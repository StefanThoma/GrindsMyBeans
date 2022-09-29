library(dplyr)
jx_pro_label <- expand.grid(c(0:5), c(0:9), c(0:3)) %>% as_tibble() %>% 
  arrange(Var1, Var2) %>%
  tibble::rownames_to_column() %>% 
  filter(rowname %in% as.character(1:201))

jx_pro_label_p <- paste(jx_pro_label$Var1, jx_pro_label$Var2, jx_pro_label$Var3, sep = "-")


zpresso_jx_pro <- data.frame(
  setting = 0:200,
  label = c(jx_pro_label_p)
)
readr::write_csv(file = "grinders/1zpresso_jx_pro.csv", zpresso_jx_pro)

# get a logical vector indicating which settings are inbetween the limits based on labels.
get_l <- function(data, limits, shift = 0){
  data$setting + shift >= data$setting[data$label == limits[1]] & 
    data$setting + shift <= data$setting[data$label == limits[2]]
}


assign_l <- function(data, shift = 0){
  
  turkish <- get_l(data = data, limits = c("0-8-0", "1-2-0"), shift = shift)
  espresso <- get_l(data = data, limits = c("1-2-0", "1-6-0"), shift = shift)
  aeropress <- moka_pot <- drip_coffee_maker <- get_l(data = data, limits = c("2-4-0", "3-0-0"), shift = shift)
  siphon <- pour_over <-  get_l(data = data, limits = c("3-2-0", "4-4-0"), shift = shift)
  french_press <- get_l(data = data, limits = c("4-2-0", "5-0-0"), shift = shift)
  
  cbind(data, 
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


