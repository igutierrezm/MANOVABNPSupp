# Reproduce data/box1950-g-v2.csv

## Load the relevant libraries in all workers
using CSV, DataFrames, MANOVABNPTest, LinearAlgebra, Random, StaticArrays, Statistics

## Import the cleaned dataset
df = DataFrame(CSV.File("data-raw/box1950.csv"));

## Extract (y, x) from the data
Y = convert(Matrix, df[!, 2:5]);
Y = (Y .- mean(Y, dims = 1)) ./ std(Y, dims = 1);
y = [SVector{4}(Y[i, :]) for i ∈ 1:nrow(df)];
x = df[!, 1];

## Fit the model
rng = MersenneTwister(1);
grid = LinRange(-4, 4, 100) |> collect;
m = MANOVABNPTest.Model(D = 4; ζ0 = 3.0);
pγ1, fgrid = MANOVABNPTest.fit(m, y, x, grid; iter = 100, rng = rng);
pγ1, fgrid = MANOVABNPTest.fit(m, y, x, grid; iter = 10000, rng = rng);

## Save the results in csv format
CSV.write("data/box1950-g-v2.csv", DataFrame(pr = pγ1));
