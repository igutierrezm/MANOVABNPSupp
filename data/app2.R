# Reproduce data/app2.csv

## Load the relevant libraries
library(dplyr)

## Clean data/wines.csv
df <- 
    read.csv("data/wines.csv") %>%
    dplyr::filter(strain == "Cs") %>%
    dplyr::select(-starts_with(c("strain", "harvest"))) %>%
    dplyr::mutate(across(-starts_with("valley"), scale)) %>%
    rename(group = valley, group_id = valley_id)


## Save the result in csv format
write.csv(df, "data/app2.csv", row.names = FALSE)
