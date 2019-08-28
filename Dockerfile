FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

#Base configuration for neurodebian
RUN apt-get update && apt-get install -y\
    wget\
    gnupg\ 
    python3=3.6.7*\
    python3-pip\
    liblapack-dev \
    gfortran \
    nodejs \ 
    npm \
    zlibc \
# pip
    && pip3 install \
    wheel \
    jupyter==1.0.0 \
    jupyterlab==0.33.12 \
    && jupyter labextension install jupyterlab_vim \
    && rm -rf /var/lib/apt/lists/* 

EXPOSE 8888
RUN mkdir /.local && chmod -R 777 /.local &&\
    mkdir /.jupyter && chmod -R 777 /.jupyter &&\
    mkdir /.julia && chmod -R 777 /.julia


ENV HOME /data
COPY ./.jupyter /data/.jupyter
COPY ./julia-1.1.1 /app/julia-1.1.1
COPY ./set_up_lab.jl /app/set_up_lab.jl
COPY ./start_notebook.jl /app/start_notebook.jl
ENV PATH=/app/julia-1.1.1/bin:${PATH}
RUN julia /app/set_up_lab.jl
COPY ./startup.sh /app/startup.sh

# Command to run at startup
# run with: 
# docker run -it --user=$UID:$UID -p 8888:8888 -v $(pwd):/data <container_name>
# Tip: Set up a bashrc function:
# function JULAB { docker run -it --user=$UID:$UID -p 8888:8888 -v $(pwd):/data <container_name>; }
WORKDIR /data
ENTRYPOINT ["/bin/bash", "/app/startup.sh"]
CMD [""]


