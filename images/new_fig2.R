# Reproduce images/fig2.pdf

## Load the relevant libraries
library(dplyr)
library(ggplot2)
library(readr)

## Set the group labels
lbls <- c(
    "control", 
    "treatment-1", 
    "treatment-2"
)

## Create the plot
pts <- 
    read.csv("data-raw/box1950.csv") %>%
    dplyr::mutate(
        group = factor(group, labels = lbls),
        y1 = (y1 - mean(y1)) / sd(y1),
        y2 = (y2 - mean(y2)) / sd(y2),
        y3 = (y2 - mean(y3)) / sd(y3),
        y4 = (y2 - mean(y4)) / sd(y4),
    )

cntrs <-
    readr::read_csv("data/new_fig2_fgrid.csv") %>%
    dplyr::mutate(group = factor(j, labels = lbls)) %>%
    dplyr::filter(var1 == 1, var2 == 2)

p <- 
    cntrs %>%
    ggplot(aes(colour = group)) +
    geom_point(data = pts, aes(y1, y2, colour = group))


    geom_contour(aes(x = y1, y = y2, z = f), binwidth = 0.05, size = 0.2)

+
    geom_point(data = pts, aes(y1, y2, colour = group)) +
    labs(
        x = "number of bacilli inhaled per tubercle formed (z-score)",
        y = "tubercle size (z-score)",
        colour = "treatment group"
    ) +
    theme_linedraw() +
    theme(
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        # legend.position  = "top"
    )
ggsave("images/new_fig2.pdf", p, width = 6, height = 5)
ggsave("images/new_fig2.eps", p, width = 6, height = 5)

# TODO
# Reemplazar los grupos por siglas.
# Poner en el caption el significado de cada sigla.