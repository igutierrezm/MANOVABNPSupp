# Reproduce data/webfig4.csv

## Load the relevant libraries in all workers
using CSV, DataFrames, Future, LinearAlgebra, MANOVABNPTest, Random, RCall, StatsBase

## Simulate a sample of size `N` under model `l` with `γ = γvec(4, γc)`
function simulate_sample(rng::AbstractRNG, N, l, γc)
    P = LinearAlgebra.cholesky([1.0 0.3; 0.3 1.0])
    k = [0.625 1.498 1.162; 0.819 1.806 1.359; 1.051 1.994 1.652]
    ỹ = [P.L * Random.randn(rng, 2) for i ∈ 1:N]
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
    return vcat(ỹ'...), x
end

## Compute all combinations of (N, l, γc, r), with r = 1:1
θs = collect(Iterators.product([200, 600, 1200], 1:3, 1:8, 1:100))[:];

## Create a specific, nonoverlapping seed for each θ ∈ θs
rngs = [MersenneTwister(1)];
for i ∈ 2:length(θs)
    push!(rngs, Future.randjump(rngs[i-1], big(10)^20))
end;

## Run the experiment for each θ ∈ θs
γ = zeros(Int, 4)
fits = map(enumerate(θs)) do (index, (N, l, γc, r))
    rng = rngs[index];
    y, x = simulate_sample(rng, N, l, γc);
    for k ∈ 2:4
        xk = x[x .∈ Ref([1, k])]
        yk = y[x .∈ Ref([1, k]), :]
        df = DataFrame(y1 = yk[:, 1], y2 = yk[:, 2], x = xk)
        γ[k] = rcopy(R"summary(manova(cbind(y1, y2) ~ x, data = $df), intercept = TRUE, test = 'Hotelling')$stats[2, 6] <= 0.05 / 3")
    end
    N, l, r, γstr(4, γc), γstr(4, γcode(γ)), 1
end;

## Save the results in csv format
df = DataFrame(fits) |> 
    x -> rename!(x, [:N, :l, :r, :H0, :H1, :value]) |>
    x -> DataFrames.groupby(x, [:N, :l, :H0, :H1]) |>
    x -> DataFrames.combine(x, :value => (x -> sum(x) / 100) => :value)
CSV.write("data/webfig4.csv", df, quotestrings = true)