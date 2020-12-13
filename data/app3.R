# Reproduce data/app3.csv

## Load the relevant libraries
library(dplyr)

## Clean data/wines.csv
df <- 
    read.csv("data/wines.csv") %>%
    dplyr::filter(strain == "Cs") %>%
    dplyr::select(-starts_with(c("strain", "valley"))) %>%
    dplyr::mutate(across(-starts_with("harvest"), scale)) %>%
    rename(group = harvest, group_id = harvest_id)

## Save the result in csv format
write.csv(df, "data/app3.csv", row.names = FALSE)
