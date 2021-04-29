library(dplyr)
library(purrr)
df <- 
    read.csv("data/ml_naive.csv") %>% 
    purrr::map(~ dplyr::cummean(exp(.x))[seq.int(9000, 10000, 20)])
    
for (i in 1:8) {
    jpeg(file=paste0("images/ml_naive_", i, ".jpeg"))
    p <- plot(df[[i]])
    dev.off()
}
