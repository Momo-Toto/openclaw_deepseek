# Use the official Node 24 image (OpenClaw requires Node 22+)
FROM node:24-bookworm-slim

# Switch to root to install system-level packages
USER root

# Install git, curl, python, and scientific libraries
RUN apt-get update && apt-get install -y \
    git \
    curl \
    python3 \
    python3-pip \
    python3-numpy \
    python3-scipy \
    python3-matplotlib \
    && rm -rf /var/lib/apt/lists/*

# Install OpenClaw globally
RUN npm install -g openclaw@latest

# Switch to the built-in, non-root 'node' user for security
USER node

# Set the working directory where the agent will write code
WORKDIR /home/node/workspace

# Start a standard bash shell by default
CMD ["/bin/bash"]
