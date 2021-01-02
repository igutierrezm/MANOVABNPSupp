# Reproduce images/fig6.pdf

## Load the relevant libraries
library(dplyr)
library(tidyr)
library(ggplot2)
library(ggthemr)
ggthemr("fresh", type = "outer", layout = "minimal", spacing = 2)

## Capture x and y labels
df_app <- 
    read.csv("data/app1.csv") %>%
    dplyr::select(Cy, Mv, group, group_id)
xlbl <- df_app %>% dplyr::select(group, group_id) %>% unique()

##
p <- 
    read.csv("data/fig9.csv") %>%
    dplyr::rename(Cy = y1, Mv = y2) %>%
    dplyr::inner_join(xlbl, by = c("j" = "group_id")) %>%
    ggplot(aes(colour = group)) +
    geom_contour(aes(x = Cy, y = Mv, z = f), binwidth = 0.0025, size = 0.2) +
    geom_point(data = df_app, aes(x = Cy, y = Mv, colour = group)) +
    theme(legend.position="top") +
    labs(
        x = "log-concentration (z-score)", 
        y = "log-concentration (z-score)",
        color = "grape variety"
    )
ggsave("images/fig9.pdf", p, width = 6, height = 5)