library(dplyr)
jx_pro_label <- expand.grid(c(0:4), c(0:9), c(0:3)) %>% as_tibble() %>% 
  arrange(Var1, Var2)
jx_pro_label <- paste(jx_pro_label$Var1, jx_pro_label$Var2, jx_pro_label$Var3, sep = "-")
zpresso_jx_pro <- data.frame(
  setting = 0:200,
  label = c(jx_pro_label, "5-0-0"),
  espresso = c(rep(0, 48), rep(1, 17), rep(0, 136))
)
readr::write_csv(file = "grinders/1zpresso_jx_pro.csv", zpresso_jx_pro)
