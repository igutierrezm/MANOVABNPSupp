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

FROM dev AS build
RUN eval "$(ssh-agent -s)"
RUN ssh-add ~/.ssh/id_rsa
RUN ssh -T git@github.com

# FROM scratch AS product
# COPY --from=build /manovabnp/main.html .

# Build and run for development
# docker build --target dev -t manovabnp:dev .
# docker run \
#     --rm \
#     --name manovabnp \
#     -d \
#     -p 8787:8787 \
#     -e "ROOT=TRUE" \
#     -e PASSWORD=123 \
#     -v $HOME/.gitconfig:/home/rstudio/.gitconfig \
#     -v $HOME/.ssh:/home/rstudio/.ssh \
#     manovabnp:dev