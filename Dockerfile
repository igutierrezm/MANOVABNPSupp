FROM rocker/verse:4.0.3 AS dev
RUN wget https://packagecloud.io/github/git-lfs/packages/debian/buster/git-lfs_2.13.1_amd64.deb/download
RUN sudo dpkg -i download
RUN git lfs install
RUN wget https://julialang-s3.julialang.org/bin/linux/x64/1.5/julia-1.5.3-linux-x86_64.tar.gz
RUN tar -xvzf julia-1.5.3-linux-x86_64.tar.gz
RUN sudo cp -r julia-1.5.3 /opt/
RUN sudo ln -s /opt/julia-1.5.3/bin/julia /usr/local/bin/julia
RUN sudo apt --assume-yes autoremove -f
RUN rm -rf julia-1.5.3*

# FROM dev AS build
# COPY . /manovabnp
# WORKDIR /manovabnp
# RUN R -e 'renv::deactivate()'
# RUN R -e "rmarkdown::render('main.Rmd')"

# FROM scratch AS product
# COPY --from=build /manovabnp/main.html .

# Build and run for development
# docker build --target dev -t manovabnp:dev .
# docker run --name manovabnp -p 8787:8787 -e PASSWORD=123 -v ~/.gitconfig:/etc/gitconfig manovabnp:dev