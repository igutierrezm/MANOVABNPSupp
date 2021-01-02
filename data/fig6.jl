# Reproduce data/fig6.csv

## Load the relevant libraries in all workers
using CSV, DataFrames, MANOVABNPTest, Random, StaticArrays

## Import the cleaned dataset
df = DataFrame(CSV.File("data/app1.csv"));

## Extract (y, x) from the data
Y = convert(Matrix, df[!, 1:9]);
y = [SVector{9}(Y[i, :]) for i ∈ 1:nrow(df)];
x = df[!, 11];

## Fit the model
rng = MersenneTwister(1);
m = MANOVABNPTest.Model(D = 9);
grid = LinRange(-4, 4, 100) |> collect;
pγ1 = zeros(4)
for i in 1:50
    pγ1 .+= MANOVABNPTest.fit(m, y, x; iter = 20000, rng = rng, K = 20)
    println(i)
end
pγ1 / 50

pγ1, fgrid = MANOVABNPTest.fit(m, y, x, grid; iter = 8000, rng = rng);

## Save the results in csv format
CSV.write("data/fig6.csv", fgrid);