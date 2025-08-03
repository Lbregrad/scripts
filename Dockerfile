# Base image
FROM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8
ENV NVIM_CONFIG=/root/.config/nvim

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
    git \
    libelf-dev \
    cpio \
    xz-utils \
    qemu-system-x86 \
    unzip \
    ripgrep \
    fd-find \
    vim \
    nano \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Setup Neovim configuration
RUN mkdir -p $NVIM_CONFIG/lua && \
    mkdir -p /root/.local/share/nvim/site/pack/packer/start && \
    git clone --depth 1 https://github.com/wbthomason/packer.nvim \
    /root/.local/share/nvim/site/pack/packer/start/packer.nvim

# Add basic init.lua configuration
RUN echo ' \
-- Packer bootstrap \
vim.cmd [[packadd packer.nvim]] \
require("packer").startup(function(use) \
  use "wbthomason/packer.nvim" \
  use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" } \
  use "nvim-telescope/telescope.nvim" \
  use "nvim-lua/plenary.nvim" \
  use "kyazdani42/nvim-tree.lua" \
  use "L3MON4D3/LuaSnip" \
  use "neovim/nvim-lspconfig" \
end) \
\
-- Basic settings \
vim.o.number = true \
vim.o.relativenumber = true \
vim.o.tabstop = 4 \
vim.o.shiftwidth = 4 \
vim.o.expandtab = true \
' > $NVIM_CONFIG/init.lua

# Set working directory
WORKDIR /workspace

# Default command
CMD ["/bin/bash"]
