# Reproduce data/app1.csv
library(magrittr)
df <- 
    readRDS("data/wines.rds") %>%
    dplyr::select(-valley, -harvest) %>%
    dplyr::rename(group = strain) %>%
    dplyr::mutate(
        dplyr::across(-group, scale), 
        group_id = as.numeric(group)
    ) %T>%
    write.csv("data/app1.csv", row.names = FALSE)
