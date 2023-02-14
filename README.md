
## Run CUDA in Docker


    curl -s -L https://nvidia.github.io/nvidia-container-runtime/gpgkey | sudo apt-key add -
    distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
    curl -s -L https://nvidia.github.io/nvidia-container-runtime/$distribution/nvidia-container-runtime.list |\
    sudo tee /etc/apt/sources.list.d/nvidia-container-runtime.list
    sudo apt-get update
    sudo apt-get install nvidia-container-runtime


## Run

* `docker build . --tag='jupyter'`
* `docker run -d --restart=unless-stopped --gpus all -p 8888:8888 -e JUPYTER_TOKEN=<token> --name jupyter jupyter`
