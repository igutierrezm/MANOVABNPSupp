using Random, MANOVABNPTest, StaticArrays, LinearAlgebra, StatsBase

function test_sample_01(D::Int, h::Int, l::Int, H0::Int)
    N = 4 * [50, 150, 300]
    K = [
        0.625 1.498 1.162;
        0.819 1.806 1.359;
        1.051 1.994 1.652
    ]
    γ = γvector(4, H0)
    Σ = cholesky(collect(I(D)))
    x = 1 .+ (0:N[h]-1) .% 4
    y = rand(N[h], D) * Σ.U
    for i in 1:N[h]
        x[i] == 2 && (y[i, :] .+= K[l, 1] * γ[2])
        x[i] == 3 && (y[i, :] .*= K[l, 2] ^ γ[3])
        x[i] == 4 && (y[i, :] .+= K[l, 3] * γ[4] * rand([-1, 1]))
    end
    ȳ, S = mean_and_cov(y)
    y = (y .- ȳ) / cholesky(S).U
    y = [SVector{D}(y[i, :]) for i ∈ 1:N[h]]
    return y, x
end

function rcat(rng, w, wsum)
    u = wsum * rand(rng)
    wpsum = 0.0
    k = 0
    while wpsum < u
        k += 1
        wpsum += w[k]
    end
    k
end

function update_z!(rng, z, α)
    z[1] = 1
    A = [1]
    n = [1.0, α]
    N = length(z)
    for i = 2:N
        j = rcat(rng, n, α + i - 1)
        if (j == length(n))
            n[end] = 0.0
            push!(n, α)
        end
        n[j] += 1
        z[i] = j
    end
end

function mlfun(nsim, H0)
    rng = MersenneTwister(1);
    D = 2
    m = MANOVABNPTest.Model(; D)
    y, x = test_sample_01(D, 1, 1, 8)
    J = length(unique(x))
    N = length(y)
    s = SuffStats(m = m, y = y, x = x)
    c = ChainState(N = s.N, J = s.J, rng = rng, K = [5])

    mlvec = zeros(nsim)
    for sim = 1:nsim
        # Recompute the clusters
        update_z!(rng, c.z, c.α[1])
        empty!(c.O)
        push!(c.O, unique(c.z)...)
        c.γ[:] = γvector(4, H0)
    
        # Recompute the sufficient statistics
        suffstats!(s, c)
    
        # Recompute the marginal likelihood
        ml = 0.0
        for k ∈ c.O
            ml += log_ml(s, 1, k)
            for j = 2:J
                if c.γ[j] == 1
                    ml += log_ml(s, j, k)
                end
            end
        end
        mlvec[sim] = exp(ml)
    end
    mlvec
end

a = [mlfun(1000000, H0) for H0 in 1:8]
mean(a[8])
