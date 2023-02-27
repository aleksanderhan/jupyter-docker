FROM nvidia/cuda:12.0.1-runtime-ubuntu22.04

WORKDIR /app/

RUN apt update && apt upgrade -y

# Install all OS dependencies for fully functional notebook server
RUN DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends \
    # Common useful utilities
    git \
    unzip \
	python3-pip \
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
	jupyterlab

# Add Tini. Tini operates as a process subreaper for jupyter. This prevents kernel crashes.
ADD https://github.com/krallin/tini/releases/download/v0.19.0/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini

ENTRYPOINT ["/usr/bin/tini", "--"]
EXPOSE 8888
CMD ["jupyter", "lab", "--port=8888", "--no-browser", "--ip=0.0.0.0", "--allow-root"]