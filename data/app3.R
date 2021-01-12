# Reproduce data/app3.csv
library(magrittr)
df <- 
    readRDS("data/wines.rds") %>%
    dplyr::filter(strain == "Cs") %>%
    dplyr::select(-strain, -valley) %>%
    dplyr::rename(group = harvest) %>%
    dplyr::mutate(
        across(-group, scale),
        group_id = as.numeric(group)
    ) %T>%
    write.csv("data/app3.csv", row.names = FALSE)
