# Reproduce data/app1.csv

## Load the relevant libraries
library(dplyr)

## Clean data/wines.csv
df <- 
    read.csv("data/wines.csv") %>%
    dplyr::select(-starts_with(c("valley", "harvest"))) %>%
    dplyr::mutate(across(-starts_with("strain"), scale)) %>%
    rename(group = strain, group_id = strain_id)

## Save the result in csv format
write.csv(df, "data/app1.csv", row.names = FALSE)
