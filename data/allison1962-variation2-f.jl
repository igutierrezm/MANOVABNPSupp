# Reproduce data/app1-variation2-f.csv

## Load the relevant libraries in all workers
using CSV, DataFrames, MANOVABNPTest, Random, StaticArrays, Statistics

## Import the cleaned dataset
df = DataFrame(CSV.File("data-raw/allison1962.csv"));

## Extract (y, x) from the data
Y = convert(Matrix, df[!, 2:3]);
Y = (Y .- mean(Y, dims = 1)) ./ std(Y, dims = 1);
y = [SVector{2}(Y[i, :]) for i ∈ 1:nrow(df)];
x = df[!, 1];

## Fit the model
rng = MersenneTwister(1);
grid = LinRange(-4, 4, 100) |> collect;
m = MANOVABNPTest.Model(D = 2; S0 = cholesky(2 * collect(I(2))));
pγ1, fgrid = MANOVABNPTest.fit(m, y, x, grid; iter = 10, rng = rng);
pγ1, fgrid = MANOVABNPTest.fit(m, y, x, grid; iter = 10000, rng = rng);

## Save the results in csv format
CSV.write("data/app1-variation2-f.csv", fgrid);
