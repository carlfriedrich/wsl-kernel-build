FROM ubuntu:24.04

RUN apt-get update && apt-get install -y \
    build-essential \
    flex \
    bison \
    dwarves \
    libssl-dev \
    libelf-dev \
    bc \
    git \
    python3 \
    pahole \
    cpio \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /src
