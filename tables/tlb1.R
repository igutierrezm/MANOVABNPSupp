# Reproduce tables/tbl1.tex

## Import the cleaned dataset
df <- 
    read.csv("data/app1.csv") %>%
    dplyr::arrange(group_id);

## Extract (y, x) from the data
y <- as.matrix(df[, 2:5]);
x <- df[, 6];

## Fit the model with the best competitor
pval <- rep(0, max(x) - 1)
for (k in 2:max(x)) {
    xk <- x[x %in% c(1, k)]
    yk <- y[x %in% c(1, k), ]
    pval[k - 1] <- LPKsample::GLP(yk, xk)[["pval"]]
}

## Save the results 
df1 <-
    df %>%
    dplyr::distinct(group, group_id) %>%
    dplyr::filter(group_id != 1) %>%
    dplyr::arrange(group_id) %>%
    dplyr::select(group) %>%
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

LPKsample::GLP(y, x)[["pval"]]
