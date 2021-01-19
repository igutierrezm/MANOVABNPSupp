# Reproduce images/fig8.pdf

## Load the relevant libraries
library(dplyr)
library(tidyr)
library(ggplot2)
library(ggthemr)
ggthemr("fresh", type="outer", layout="minimal", spacing=2)

## Capture x and y labels
df_app <- read.csv("data/app3.csv")
ylbl <- names(df_app)[2:5]
xlbl <- df_app %>% dplyr::select(group, group_id) %>% unique()

##    
df_point1 <-
    df_app %>%
    dplyr::mutate(i = dplyr::row_number()) %>%
    dplyr::select(group, group_id, i, Dp, Cy) %>%
    tidyr::pivot_longer(cols = c("Dp", "Cy")) %>%
    dplyr::rename(var1 = name, x1 = value)
head(df_point1)

df_point2 <-
    df_app %>%
    dplyr::mutate(i = dplyr::row_number()) %>%
    dplyr::select(group, group_id, i, Pe, Mv) %>%
    tidyr::pivot_longer(cols = c("Pe", "Mv")) %>%
    dplyr::rename(var2 = name, x2 = value)

df_point <- 
    dplyr::full_join(df_point1, df_point2) %>%
    dplyr::mutate(group = as.character(group))

##
p <- 
    read.csv("data/fig8.csv") %>%
    dplyr::inner_join(xlbl, by = c("j" = "group_id")) %>%
    dplyr::filter(j %in% c(1, 3)) %>%
    dplyr::mutate(group = as.character(group)) %>%
    dplyr::mutate_at(c("var1", "var2"), ~factor(.x, 1:9, ylbl)) %>%
    dplyr::filter(var1 %in% c("Dp", "Cy")) %>%
    dplyr::filter(var2 %in% c("Pe", "Mv")) %>%
    ggplot(aes(colour = group)) +
    geom_contour(aes(x = y1, y = y2, z = f), binwidth = 0.0025, size = 0.2) +
    geom_point(data = df_point, aes(x1, x2, colour = group)) + 
    facet_grid(var1 ~ var2) +
    theme_linedraw() +
    theme(
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank()
    ) +
    theme(legend.position="top") +
    labs(
        x = "log-concentration (z-score)", 
        y = "log-concentration (z-score)",
        color = "harvest"
    )
ggsave("images/fig8.pdf", p, width = 6, height = 5)

##
head(df_app)
Y <- as.matrix(df_app[, 1:9])
x <- df_app$group_id
LPKsample::GLP(Y, x)
