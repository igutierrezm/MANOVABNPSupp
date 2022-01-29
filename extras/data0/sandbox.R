library(JuliaConnectoR)
library(readr)
juliaEval('Pkg.add(url = "https://github.com/igutierrezm/MANOVABNPTest.jl")')
MANOVABNPTest <- juliaImport('MANOVABNPTest')
Random <- juliaImport('Random')
df <- read_csv("data-raw/allison1962.csv")

## Extract (y, x) from the data
y <- as.matrix(df[, 2:3])
x <- as.integer(df[[1]])
rng <- Random$MersenneTwister(1L)
fit <- MANOVABNPTest$train(y, x, iter = 10000L, rng = rng)

## Fit the model
rng = MersenneTwister(1);
m = MANOVABNPTest.Model(D = 2);
grid = LinRange(-4, 4, 100) |> collect;
pγ1, fgrid = MANOVABNPTest.fit(m, y, x, grid; iter = 10, rng = rng);
pγ1, fgrid = MANOVABNPTest.fit(m, y, x, grid; iter = 10000, rng = rng);

## Save the results in csv format
CSV.write("data/allison1962-f.csv", fgrid);
