# Reproduce data/fig9.csv

## Load the relevant libraries in all workers
using CSV, DataFrames, MANOVABNPTest, Random, StaticArrays

## Import the cleaned dataset
df = CSV.File("data/app1.csv") |>
    x -> DataFrame(x) |> 
    x -> select(x, [:Cy, :Mv, :group_id]);

## Extract (y, x) from the data
Y = convert(Matrix, df[!, 1:2]);
y = [SVector{2}(Y[i, :]) for i ∈ 1:nrow(df)];
x = df[!, 3];

## Fit the model
rng = MersenneTwister(1);
m = MANOVABNPTest.Model(D = 2);
MANOVABNPTest.fit(m, y, x; iter = 2000, rng = rng, K = 20)
pγ1 = zeros(4)
for i in 1:50
    pγ1 .+= MANOVABNPTest.fit(m, y, x; iter = 2000, rng = rng, K = 20)
    println(i)
end
pγ1 / 50

rng = MersenneTwister(1);
grid = LinRange(-4, 4, 100) |> collect;
pγ1, fgrid = MANOVABNPTest.fit(m, y, x, grid; iter = 20000, rng = rng);

## Save the results in csv format
CSV.write("data/fig9.csv", fgrid);