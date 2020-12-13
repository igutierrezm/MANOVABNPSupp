# Reproduce data/fig8.csv

## Load the relevant libraries in all workers
using CSV, DataFrames, MANOVABNPTest, Random, StaticArrays

## Import the cleaned dataset
df = DataFrame(CSV.File("data/app3.csv"));

## Extract (y, x) from the data
Y = convert(Matrix, df[!, 1:9]);
y = [SVector{9}(Y[i, :]) for i ∈ 1:nrow(df)];
x = df[!, 11];

## Fit the model
rng = MersenneTwister(1);
m = MANOVABNPTest.Model(D = 9);
grid = LinRange(-4, 4, 100) |> collect;
pγ1, fgrid = MANOVABNPTest.fit(m, y, x, grid; iter = 8000, rng = rng);

## Save the results in csv format
CSV.write("data/fig8.csv", fgrid);