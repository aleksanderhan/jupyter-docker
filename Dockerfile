FROM nvidia/cuda:12.0.1-runtime-ubuntu22.04

WORKDIR /app/

COPY cheatsheet.ipynb ./

RUN apt update && apt upgrade -y

# Install all OS dependencies for fully functional notebook server
RUN DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends \
    # Common useful utilities
    git \
    unzip \
	python3-pip \
    build-essentials \
    wget \
    tzdata \
    # git-over-ssh
    openssh-client \
    # nbconvert dependencies
    # https://nbconvert.readthedocs.io/en/latest/install.html#installing-tex
    texlive-xetex \
    texlive-fonts-recommended \
    texlive-plain-generic \
    # Enable clipboard on Linux host systems
    xclip && \
    apt clean && rm -rf /var/lib/apt/lists/*		

RUN pip3 install \
	numpy \
    pandas \
    scipy \
	torch \
	torchvision \
	torchaudio \
	jupyterlab \
    virtualenv


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
CMD ["jupyter", "lab", "--port=8888", "--no-browser", "--ip=0.0.0.0", "--allow-root"]