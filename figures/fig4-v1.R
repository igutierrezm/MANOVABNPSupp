# Reproduce figures/fig4-v1.eps

## Load the relevant libraries
library(dplyr)
library(ggplot2)
library(readr)

## Create the plot
p <-
    readr::read_csv("data/fig4-v1-g.csv") %>%
    dplyr::mutate(
        N = factor(N),
        l = factor(l, labels = c("low", "medium", "large")),
        H0 = factor(H0),
        H1 = factor(H1)
    ) %>%
    ggplot(aes(H0, H1)) +
    geom_tile(aes(fill = value), color = "grey90") +
    facet_grid(l ~ N) +
    labs(
        y = "Hypothesis, by discrepancy between the group distributions",
        x = expression(paste("True hypothesis, by sample size"))
    ) +
    theme_classic() +
    theme(legend.position = "top") +
    scale_fill_gradient(low = "white", high = "black") +
    theme(axis.text.x = element_text(angle = 90))

## Save the plot in pdf format
ggsave("figures/fig4-v1.eps", p, width = 6, height = 5)
