FROM nvidia/cuda:12.0.1-runtime-ubuntu22.04

RUN apt update && apt upgrade -y
RUN apt install jupyter -y

COPY jupyter_notebook_config.py /root/.jupyter/

# Add Tini. Tini operates as a process subreaper for jupyter. This prevents kernel crashes.
ADD https://github.com/krallin/tini/releases/download/v0.6.0/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini


ENTRYPOINT ["/usr/bin/tini", "--"]
EXPOSE 8888
CMD ["jupyter", "notebook", "--port=8888", "--no-browser", "--ip=0.0.0.0", "--allow-root"]