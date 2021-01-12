# Reproduce data/app2.csv
library(magrittr)
df <- 
    readRDS("data/wines.rds") %>%
    dplyr::filter(strain == "Cs") %>%
    dplyr::select(-strain, -harvest) %>%
    dplyr::rename(group = valley) %>%
    dplyr::mutate(
        across(-group, scale), 
        group_id = as.numeric(group)
    ) %T>%
    write.csv("data/app2.csv", row.names = FALSE)
