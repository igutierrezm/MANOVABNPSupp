# Reproduce images/fig5.pdf

## Load the relevant libraries
library(dplyr)
library(ggplot2)
library(readr)

## Create the plot
p <-
    readr::read_csv("data/fig5.csv") %>%
    dplyr::mutate(
        N = factor(N),
        l = factor(l, labels = c(-.5, 0, .5)),
        H0 = factor(H0),
        H1 = factor(H1)
    ) %>%
    ggplot(aes(H0, H1)) +
    geom_tile(aes(fill = value), color = "grey90") +
    facet_grid(l ~ N) +
    labs(
        y = "Hypothesis, by level of inter-correlation",
        x = expression(paste("True hypothesis, by sample size"))
    ) +
    theme_classic() +
    theme(legend.position = "top") +
    scale_fill_gradient(low = "white", high = "black") +
    theme(axis.text.x = element_text(angle = 90))

## Save the plot in pdf format
ggsave("images/fig5.pdf", p, width = 6, height = 5)
ggsave("images/fig5.eps", p, width = 6, height = 5)
