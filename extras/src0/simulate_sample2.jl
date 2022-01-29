"""
Simulate a sample of size `N` for experiment 2, 
under model `l` and `γ = γvec(4, γc)`
"""
function simulate_sample1(rng::AbstractRNG, N, l, γc)
    δ = [-0.5, 0.0, +0.5]
    P = LinearAlgebra.cholesky([1.0 δ[l]; δ[l] 1.0])
    k = [0.625 1.498 1.162; 0.819 1.806 1.359; 1.051 1.994 1.652]
    ỹ = [P.L * Random.randn(rng, 2) for i ∈ 1:N]
    x = [1 + (i - 1) % 4 for i ∈ 1:N]
    γ = γvec(4, γc)
    for i in 1:N
        zi = rand(rng, [-1, 1])
        x[i] == 2 && (ỹ[i] .+= (γ[1] * k[1, 1] + 0))
        x[i] == 3 && (ỹ[i] .*= (γ[2] * k[1, 2] + 1)^(1/2))
        x[i] == 4 && (ỹ[i] .+= (γ[3] * k[1, 3] + 0) * zi)
    end
    μ, σ = StatsBase.mean_and_std(ỹ)
    for i ∈ 1:N
        @. ỹ[i] = (ỹ[i] - μ) / σ
    end
    return ỹ, x
end
