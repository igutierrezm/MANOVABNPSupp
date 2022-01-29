# Reproduce data/fig5.csv

## Load the relevant libraries in all workers
using CSV, DataFrames, MANOVABNPTest, Random, StaticArrays, Statistics

## Import the cleaned dataset
df = DataFrame(CSV.File("data-raw/box1950.csv"));

## Extract (y, x) from the data
Y = convert(Matrix, df[!, 2:5]);
Y = (Y .- mean(Y, dims = 1)) ./ std(Y, dims = 1);
y = [SVector{4}(Y[i, :]) for i ∈ 1:nrow(df)];
x = df[!, 1];

## Fit the model
rng = MersenneTwister(1);
m = MANOVABNPTest.Model(D = 4);
grid = LinRange(-4, 4, 100) |> collect;
pγ1, fgrid = MANOVABNPTest.fit(m, y, x, grid; iter = 100, rng = rng);
pγ1, fgrid = MANOVABNPTest.fit(m, y, x, grid; iter = 10000, rng = rng);

## Save the results in csv format
CSV.write("data/new_fig2_fgrid.csv", fgrid);
CSV.write("data/new_fig2_pg.csv", DataFrame(pr = pγ1));
