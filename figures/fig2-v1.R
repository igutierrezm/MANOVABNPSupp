# Reproduce figures/fig2-v1.eps

## Load the relevant libraries
library(dplyr)
library(ggplot2)
library(readr)

## Set the group labels
lbls <- c(
    "control", 
    "treatment-1", 
    "treatment-2",
    "treatment-3"
)

## Create the plot
pts <- 
    readr::read_csv("data/allison1962.csv") %>%
    dplyr::mutate(
        group = factor(group, labels = lbls),
        y1 = (y1 - mean(y1)) / sd(y1),
        y2 = (y2 - mean(y2)) / sd(y2)
    )

cntrs <-
    readr::read_csv("data/fig2-v1-f.csv") %>%
    dplyr::mutate(group = factor(j, labels = lbls))

p <- 
    cntrs %>%
    ggplot(aes(colour = group)) +
    geom_contour(aes(x = y1, y = y2, z = f), binwidth = 0.05, size = 0.2) +
    geom_point(data = pts, aes(y1, y2, colour = group)) +
    labs(
        x = "number of bacilli inhaled per tubercle formed (z-score)",
        y = "tubercle size (z-score)",
        colour = "group"
    ) +
    theme_linedraw() +
    theme(
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        legend.position  = "top"
    )
p
ggsave("figures/fig2-v1.eps", p, width = 6, height = 5)
