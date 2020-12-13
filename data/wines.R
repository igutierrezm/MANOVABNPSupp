# Reproduce data/wines.csv

## Load the relevant libraries
library(dplyr)
library(stringr)

## Clean data-raw/baseconcentraciones.csv
df <- 
    read.csv("data-raw/baseconcentraciones.csv", dec = ',') %>%
    dplyr::select(Cepa, Valle, Cosecha, dplyr::matches("^(log[A-Z]).*")) %>%
    dplyr::rename_all(stringr::str_replace_all, '(log)|(mg\\.L)|\\.', '') %>%
    dplyr::mutate(
        strain  = factor(Cepa)    %>% stats::relevel(ref = "Cm"),
        valley  = factor(Valle)   %>% stats::relevel(ref = "Aconcagua"),
        harvest = factor(Cosecha) %>% stats::relevel(ref = "2004")
    ) %>%
    dplyr::mutate(across(
        c(strain, valley, harvest),
        c(id = as.numeric)
    )) %>%
    select(-Cepa, -Cosecha, -Valle)

## Save the result in csv format
write.csv(df, "data/wines.csv", row.names = FALSE)
