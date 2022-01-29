FROM rocker/r-ver:4.0.0

# Install git, glpk-utils, libxt6, wget, xml2
RUN apt-get update 
RUN apt-get -y install git glpk-utils libxt6 wget xml2

# Install some useful R packages
RUN install2.r --error --skipinstalled --ncpus -1 \
    dplyr ggplot2 JuliaConnectoR languageserver LPKsample readr tidyr

# Install julia 1.5.3
WORKDIR /opt/
ARG JULIA_TAR=julia-1.5.3-linux-x86_64.tar.gz
RUN wget -nv https://julialang-s3.julialang.org/bin/linux/x64/1.5/${JULIA_TAR}
RUN tar -xzf ${JULIA_TAR}
RUN rm -rf ${JULIA_TAR}
RUN ln -s /opt/julia-1.5.3/bin/julia /usr/local/bin/julia

# Add libR.so to the LD_LIBRARY_PATH environment variable
ARG libRdir=/usr/local/lib/R/lib
RUN echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH':$libRdir >> ~/.bashrc

# Update the libstdc++.so.6 used by julia
RUN cp /usr/lib/x86_64-linux-gnu/libstdc++.so.6 /opt/julia-1.5.3/lib/julia/

# To build this image, run
# docker build -t julia_r:1.5.3 .

# To create a container, run
# sudo docker run -t -d julia_r:1.5.3
