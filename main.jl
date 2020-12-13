using Base.Iterators, CSV, DataFrames, Distributed, Future, Random, StaticArrays
nworkers() == 8 || addprocs(8, exeflags = "--project=.")
@everywhere using MANOVABNPTest, LinearAlgebra, Random, StatsBase, StaticArrays

df = DataFrame(CSV.File("data/app1.csv"))
Y = convert(Matrix, df[!, 1:9])
y = [SVector{9}(Y[i, :]) for i ∈ 1:nrow(df)]
x = df[!, 11]

# Crea una muestra
rng = MersenneTwister(1);
m = MANOVABNPTest.Model(D = 2);
y, x = simulate_sample(rng, 200, 1, 1, 1, 1);

# Crea una grilla para cada componente de y
ygrid_1d = LinRange.(0.9 * min.(y...), 1.1 * max.(y...), Ref(100))

# Crea una grilla para y
margins = ((1, 2), (1, 2))
ygrid_2d = map(margins) do (d1, d2) 
    itr = product(ygrid_1d[d1], ygrid_1d[d2])
    [[x, y] for (x, y) ∈ itr]
end;

# Crea una grilla para fy
fgrid = [zeros(length(grid)) for grid ∈ ygrid_2d]

# Inicializa la cadena y los estadísticos auxiliares
warmup = 5
s = SuffStats(m = m, y = y, x = x);
c = ChainState(N = s.N, J = s.J, rng = rng);
pγ1 = zeros(2^(s.J - 1));
pγ0 = ph0(s.J - 1, 1.0);

# Update the chain
iter = 10;
@fastmath for t ∈ 1:iter
    suffstats!(s, c)
    update_z!(c, s)
    update_α!(c, s)
    update_γ!(c, s, pγ0)
    t > warmup || continue
    pγ1[γcode(c.γ)] += 1

    # Update fy
    for (index, grid) ∈ enumerate(ygrid_2d)
        for y0 ∈ grid
            # log_pl(s, c, i, k) + log(n[k] - (z̄ == k))
        end
    end
end





function fit(
    m::Model{A, B},
    y::Vector{C},
    x::Vector{Int},
    grid::Tuple{Int, Int, Vector{Float64}};
    iter::Int = 4000, 
    warmup::Int = iter ÷ 2,
    thin_grid::Int = 5,
    rng::MersenneTwister = MersenneTwister()
) where {A, B, C}
    # Initialization
    D = length(y[1])
    J = length(unique(x))
    s = SuffStats(m = m, y = y, x = x)
    c = ChainState(N = s.N, J = s.J, rng = rng)
    pγ1 = zeros(2^(s.J - 1))
    pγ0 = ph0(s.J - 1, 1.0)
    ygrid = Iterators.product(fill(grid, 2)...)
    ygrid = collect.(ygrid)[:] |> x -> hcat(x...)
    fgrid = [zeros(size(ygrid, 2)) for j = 1:J, z1 in 1:D, z2 in 1:D]
    M = size(ygrid, 2)

    # Updating
    @unpack γ, α, O = c
    @unpack n, N, μ, Σ = s
    @unpack r0, ν0 = m
    r1 = r0 + 1
    ν1 = ν0 + 1
    u0 = zeros(2)
    u1 = zeros(2)
    S0 = Cholesky(m.S0.factors[1:2, 1:2], :U, 0)
    S1 = deepcopy(S0)
    ggrid = zeros(M)
    yi = zeros(2)
    @fastmath for t ∈ 1:iter
        suffstats!(s, c)
        update_z!(c, s)
        update_θ!(c, s)
        update_α!(c, s)
        update_γ!(c, s, pγ0)
        t > warmup || continue
        pγ1[γcode(c.γ)] += 1

        # Compute a base contribution to f(y)
        for i in 1:M
            S1.factors .= S0.factors
            yi .= ygrid[:, i]
            u1 .= (r0 * u0 + yi) / r1
            u1 .= (yi - u1) * √(r1 / r0)
            lowrankupdate!(S1, u1)
            ggrid[i] =
                0.5ν0 * logdet(S0) -
                0.5ν1 * logdet(S1) +
                logmvgamma(2, ν1 / 2) -
                logmvgamma(2, ν0 / 2) +
                0.5 * 2 * log(r0 / r1) -
                0.5 * 2 * log(π) * (r1 - r0)
            ggrid[i] = exp(ggrid[i])
        end

        # Accumulate f(y)
        μsub = [0.0; 0.0]
        Σsub = [1.0 0.0; 0.0 1.0]
        for j = 1:J, z1 = 1:D, z2 = z1+1:D
            for k in O
                μsub .= μ[j^γ[j], k][[z1; z2]]
                Σsub .= Σ[j^γ[j], k][[z1; z2], [z1; z2]]
                fgrid[j, z1, z2] += pdf(MvNormal(μsub, Σsub), ygrid) * n[k] / (N + α[1])
            end
            fgrid[j, z1, z2] += ggrid * α[1] / (N + α[1])
        end
    end

    # Convert fgrid into a dataframe
    dfs = [
        DataFrame(
            j    = j, 
            var1 = z1, 
            var2 = z2, 
            y1   = ygrid[1, :],
            y2   = ygrid[2, :],
            f    = fgrid[j, z1, z2] / (iter - warmup)
        ) for j = 1:J, z1 = 1:D, z2 = 1:D
    ]
    df = reduce(vcat, dfs)
    filter!([:var1, :var2] => (x, y) -> x < y, df)
    return pγ1 / (iter - warmup), df
end

typeof((1, 2, [1, 2]))




















