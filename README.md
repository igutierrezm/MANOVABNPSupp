# MANNOVABNPSupp

Replication code for all the figures and simulation results displayed in the manuscript *"A new flexible Bayesian hypothesis test for multivariate data"* (Gutiérrez et al. 2022). The repository is organized as follows:

* `figures/`: contains the figures and their associated replications code.
    - `figures/figj-v1.eps`: Figure `j` in the manuscript.
    - `figures/figj-v2.eps`: A variation of Figure `j`. Here we modified the hypothesis prior distribution.
    - `figures/figj-v3.eps`: A variation of Figure `j`. Here we modified the atoms prior distribution.
    - `figures/figj-vk.R`: Replication code for `figures/figj-vk.eps`.

* `data/`: contains the raw data as well as datasets with the posterior simulations.
    - `data/figj-vk-f.csv`: The summary of the density necessary to compute `figures/figj-vk.eps`.
    - `data/figj-vk-f.csv`: The summary of `gamma` necessary to compute `figures/figj-vk.eps`.
    - `data/figj-vk-f.jl`: Replication code for `figures/figj-vk-f.csv`.
    - `data/figj-vk-g.jl`: Replication code for `figures/figj-vk-g.csv`.

* `extras/`: contains auxilliary datasets and simulations.

To replicate all the results, do as follows:

1. Install Julia and R.
2. Instantiate the Pkg environment associated with this repository.
3. Run each `.jl` file in `data/`.
4. Run each `.R` file in `data/`.

> **Tip:** We strongly recommend replicating our results using our Docker image. The neccesary `Dockerfile` is in the root directory of this repository. We recommend this because our code has many non-trivial dependencies.

> **Tip:** To reduce the computation time (and verify that everything is working correctly), the last 4 figures are computed using 1 simulated sample (instead of 100). If you want to use 100 samples in `figures/figj-vk.eps` (as we do in the manuscript), set `Nsim` to 100 in `data/figj-vk-f.jl` and `data/figj-vk-g.jl` and re-run the relevant scripts. Be aware that, depending on your computer, this can take several days to be done.
