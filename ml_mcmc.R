library(dplyr)
library(purrr)
df <- 
    read.csv("data/ml_mcmc.csv") %>%
    mutate(pH0_8 = (x2 == 1) & (x3 == 1) & (x4 == 1)) %>%
    mutate(pH0_1 = (x2 == 1) & (x3 == 0) & (x4 == 1)) %>%
    purrr::map(~ dplyr::cummean(.x)[seq.int(4000, 5000, 20)]) %>%
    as.data.frame()

for (i in 8) {
    jpeg(file=paste0("images/ml_mcmc_", i, ".jpeg"))
    p <- plot(df$pH0_8 / df$pH0_8)
    dev.off()
}
