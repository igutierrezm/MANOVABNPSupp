# Reproduce images/fig6.pdf

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
pts1 <- 
    read.csv("data-raw/box1950.csv") %>%
    dplyr::mutate(
        group = factor(group, labels = lbls),
        y1 = (y1 - mean(y1)) / sd(y1),
        y2 = (y2 - mean(y2)) / sd(y2),
        y3 = (y3 - mean(y3)) / sd(y3),
        y4 = (y4 - mean(y4)) / sd(y4),
        i  = dplyr::row_number()
    ) %>%
    tidyr::pivot_longer(cols = y1:y4, names_to = "var1", values_to = "x1")

pts2 <-
    pts1 %>%
    dplyr::rename(var2 = var1, x2 = x1)

pts <-
    dplyr::full_join(pts1, pts2) %>%
    dplyr::filter(var1 %in% c("y1", "y2"), var2 %in% c("y3", "y4"))
head(pts)

cntrs <-
    readr::read_csv("data/box1950-variation2-f.csv") %>%
    dplyr::mutate(
        group = factor(j, labels = lbls),
        var1  = paste0("y", var1),
        var2  = paste0("y", var2)
    ) %>%
    dplyr::filter(var1 %in% c("y1", "y2"), var2 %in% c("y3", "y4"))
head(cntrs)

p <- 
    cntrs %>%
    ggplot(aes(colour = group)) +
    geom_contour(aes(x = y1, y = y2, z = f), binwidth = 0.05, size = 0.2) +
    geom_point(data = pts, aes(x1, x2, colour = group)) + 
    facet_grid(var1 ~ var2) +
    labs(
        x = "",
        y = "",
        colour = "group"
    ) +
    theme_linedraw() +
    theme(
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        legend.position  = "top"
    )    
p    
ggsave("images/box1950-variation2-f.pdf", p, width = 6, height = 5)
ggsave("images/box1950-variation2-f.eps", p, width = 6, height = 5)
