using Distributions

function update_d!(rng, d, α)
    d[1] = 1
    A = [1]
    n = [1.0, α]
    N = length(d)
    for i = 2:N
        j = rand(rng, Categorical(n ./ (α + i - 1)))
        if (j == length(n))
            n[end] = 0
            push!(n, α)
            push!(A, A[end] + 1)
        end
        n[j] += 1
        d[i] = A[j]
    end
end

rng = MersenneTwister(1);
d = zeros(Int, 1000)
α = 1.0
@time update_d!(rng, d, α)