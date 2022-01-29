# Reproduce data/fig12.csv

## Load the relevant libraries in all workers
using CSV, DataFrames, Distributed, Future, Random
nworkers() == 8 || addprocs(8, exeflags = "--project=.")
@everywhere using MANOVABNPTest, LinearAlgebra, Random, StatsBase, StaticArrays

## Simulate a sample of size `N` under model `l` with `γ = γvec(4, γc)`
@everywhere function simulate_sample(rng::AbstractRNG, N, l, γc)
    P = LinearAlgebra.cholesky(I(6))
    k = [0.625 1.498 1.162; 0.819 1.806 1.359; 1.051 1.994 1.652]
    ỹ = [P.L * Random.randn(rng, 6) for i ∈ 1:N]
    x = [1 + (i - 1) % 4 for i ∈ 1:N]
    γ = γvec(4, γc)
    for i in 1:N
        zi = rand(rng, [-1, 1])
        x[i] == 2 && (ỹ[i] .+= (γ[1] * k[l, 1] + 0))
        x[i] == 3 && (ỹ[i] .*= (γ[2] * k[l, 2] + 1)^(1/2))
        x[i] == 4 && (ỹ[i] .+= (γ[3] * k[l, 3] + 0) * zi)
    end
    μ, σ = StatsBase.mean_and_std(ỹ)
    for i ∈ 1:N
        @. ỹ[i] = (ỹ[i] - μ) / σ
    end
    y = SVector{6}.(ỹ)
    return y, x
end

## Compute all combinations of (N, l, γc, r), with r = 1:1
θs = collect(Iterators.product([200], [1], 1:8, 1:100))[:];

## Create a specific, nonoverlapping seed for each θ ∈ θs
rngs = [MersenneTwister(1)];
for i ∈ 2:length(θs)
    push!(rngs, Future.randjump(rngs[i-1], big(10)^20))
end;

## Run the experiment for each θ ∈ θs
@time fits = pmap(enumerate(θs)) do (index, (N, l, γc, r))
    rng = rngs[index]
    m = MANOVABNPTest.Model(D = 6)
    y, x = simulate_sample(rng, N, l, γc)
    N, l, r, γstr(4, γc), MANOVABNPTest.fit(m, y, x; iter = 4000, rng = rng)...
end;

## Save the results in csv format
df = DataFrame(fits) |> 
    x -> rename!(x, [:N, :l, :r, :H0, Symbol.(γstr.(4, 1:8))...]) |>
    x -> stack(x, 5:12, variable_name = :H1, value_name = :value) |>
    x -> DataFrames.groupby(x, [:N, :l, :H0, :H1]) |>
    x -> DataFrames.combine(x, :value => mean => :value);
CSV.write("data/fig12.csv", df, quotestrings = true)