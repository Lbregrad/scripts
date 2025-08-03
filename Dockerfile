# Base image
FROM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8

RUN apt-get update -y

# Install essential build tools and dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    bison \
    flex \
    libncurses5-dev \
    libssl-dev \
    bc \
    wget \
    curl \
    neovim \
    libelf-dev \
    git \
    cpio \
    xz-utils \
    qemu-system-x86 \
    vim \
    nano \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create a working directory for the project
WORKDIR /workspace

# Set default command to bash
CMD ["/bin/bash"]
