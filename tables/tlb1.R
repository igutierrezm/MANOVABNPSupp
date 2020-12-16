# Reproduce tables/tbl1.tex

## Load the relevant libraries in all workers
library(dplyr)
library(LPKsample)
library(xtable)

## Import the cleaned dataset
df <- 
    read.csv("data/app1.csv") %>%
    dplyr::arrange(group_id);

## Extract (y, x) from the data
y <- as.matrix(df[, 1:9]);
x <- df[, 11];

## Fit the model with the best competitor
pval <- rep(0, max(x) - 1)
for (k in 2:J) {
    xk <- x[x %in% c(1, k)]
    yk <- y[x %in% c(1, k), ]
    g[k - 1] <- LPKsample::GLP(yk, xk)[["pval"]]
}

## Save the results 
df1 <-
    df %>%
    dplyr::select(group) %>%
    dplyr::distinct() %>%
    dplyr::slice(-1) %>%
    dplyr::mutate(`p-value` = pval) %>%
    xtable::xtable(
        type = "latex",
        caption = "
            $p$-value of each 2-sample test, using the log-concentration 
            z-scores of the nine anthocyanins as response variable, 
            grape variety as group variable, and 'Cm' 
            as reference group.
        ",
        label = "tbl:1",
    ) %>%
    print(file = "tables/tbl1.tex", include.rownames = FALSE)