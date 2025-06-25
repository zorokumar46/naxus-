FROM ubuntu:22.04

RUN apt update && DEBIAN_FRONTEND=noninteractive apt install -y curl git vim nano wget python3 python3-pip build-essential htop zram-tools docker.io tlp jq unzip nodejs npm cmake && apt clean && rm -rf /var/lib/apt/lists/*

RUN echo 'ALGO=lz4' > /etc/default/zramswap && echo 'PERCENT=50' >> /etc/default/zramswap && systemctl enable zramswap
RUN systemctl enable docker

WORKDIR /workspaces/heavyhitter

CMD ["/bin/bash"]
