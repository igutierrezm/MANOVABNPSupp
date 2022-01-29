# Reproduce data/wines.csv ----
library(magrittr)
df <- 
    read.csv("data-raw/baseconcentraciones.csv") %>%
    dplyr::select(Cepa, Valle, Cosecha, dplyr::matches("^(log[A-Z]).*")) %>%
    dplyr::rename_all(stringr::str_replace_all, '(log)|(mg\\.L)|\\.', '') %>%
    dplyr::mutate(Valle = trimws(Valle)) %>%
    dplyr::mutate(
        strain  = factor(Cepa)    %>% stats::relevel(ref = "Cm"),
        valley  = factor(Valle)   %>% stats::relevel(ref = "Aconcagua"),
        harvest = factor(Cosecha) %>% stats::relevel(ref = "2004")
    ) %>%
    dplyr::select(strain, valley, harvest, Dp, Cy, Mv, Pe) %T>%
    saveRDS("data/wines.rds")
