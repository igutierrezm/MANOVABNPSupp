# Reproduce data/webfig2.csv

## Load the relevant libraries in all workers
using CSV, DataFrames, MANOVABNPTest, Random, StaticArrays

## Import the cleaned dataset
df = DataFrame(CSV.File("data/app2.csv"));

## Extract (y, x) from the data
Y = convert(Matrix, df[!, 2:5]);
y = [SVector{4}(Y[i, :]) for i ∈ 1:nrow(df)];
x = df[!, 6];

## Fit the model
rng = MersenneTwister(1);
m = MANOVABNPTest.Model(D = 4);
grid = LinRange(-4, 4, 100) |> collect;
pγ1 = MANOVABNPTest.fit(m, y, x; iter = 10, rng = rng);
pγ1 = MANOVABNPTest.fit(m, y, x; iter = 10000, rng = rng);
pγ1, fgrid = MANOVABNPTest.fit(m, y, x, grid; iter = 10, rng = rng);
pγ1, fgrid = MANOVABNPTest.fit(m, y, x, grid; iter = 10000, rng = rng);

## Save the results in csv format
CSV.write("data/webfig2.csv", fgrid);
