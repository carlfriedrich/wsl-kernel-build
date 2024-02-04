FROM ubuntu:20.04

RUN apt-get update && apt-get install -y \
    build-essential \
    flex \
    bison \
    dwarves \
    libssl-dev \
    libelf-dev \
    bc \
    git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /src
