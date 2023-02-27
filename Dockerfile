FROM nvidia/cuda:12.0.1-runtime-ubuntu22.04

ENV SHELL=/bin/bash
WORKDIR /app/

COPY cheatsheet.ipynb ./

RUN apt update && apt upgrade -y

# Install all OS dependencies for fully functional notebook server
RUN apt update --yes && \
    apt install --yes --no-install-recommends \
    # Common useful utilities
    git \
    nano-tiny \
    unzip \
    vim-tiny \
	python3-pip \
    build-essentials \
    wget \
    # git-over-ssh
    openssh-client \
    # less is needed to run help in R
    # see: https://github.com/jupyter/docker-stacks/issues/1588
    less \
    # nbconvert dependencies
    # https://nbconvert.readthedocs.io/en/latest/install.html#installing-tex
    texlive-xetex \
    texlive-fonts-recommended \
    texlive-plain-generic \
    # Enable clipboard on Linux host systems
    xclip && \
    apt clean && rm -rf /var/lib/apt/lists/*

RUN DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt -y install tzdata		

# Create alternative for nano -> nano-tiny
RUN update-alternatives --install /usr/bin/nano nano /bin/nano-tiny 10

RUN pip3 install \
	numpy \
	torch \
    scipy \
    pandas \
	torchvision \
	torchaudio \
	jupyterlab \
    virtualenv

#COPY jupyter_notebook_config.py /root/.jupyter/

# Add Tini. Tini operates as a process subreaper for jupyter. This prevents kernel crashes.
ADD https://github.com/krallin/tini/releases/download/v0.19.0/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini

# Install miniconda
ENV CONDA_DIR /opt/conda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
     /bin/bash ~/miniconda.sh -b -p /opt/conda

# Put conda in path so we can use conda activate
ENV PATH=$CONDA_DIR/bin:$PATH


ENTRYPOINT ["/usr/bin/tini", "--"]
EXPOSE 8888
CMD ["jupyter", "notebook", "--port=8888", "--no-browser", "--ip=0.0.0.0", "--allow-root"]