# Use Debian 11 (Bullseye) as base image
FROM debian:bullseye-20240513-slim

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install essential packages including Python and Jupyter
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    python3-venv \
    git \
    curl \
    wget \
    nano \
    vim \
    htop \
    net-tools \
    iputils-ping \
    dnsutils \
    && rm -rf /var/lib/apt/lists/*

# Install Jupyter Notebook and JupyterLab
RUN python3 -m pip install --no-cache-dir --upgrade pip && \
    python3 -m pip install --no-cache-dir \
    notebook \
    jupyterlab \
    jupyterhub

# Create user with UID 1000 (required by Binder)
ARG NB_USER=jovyan
ARG NB_UID=1000
ENV USER ${NB_USER}
ENV NB_UID ${NB_UID}
ENV HOME /home/${NB_USER}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}

# Set up working directory
WORKDIR ${HOME}

# Make sure the contents of the repo are in ${HOME}
COPY . ${HOME}

# Change ownership to the non-root user
USER root
RUN chown -R ${NB_UID}:${NB_UID} ${HOME}

# Switch to non-root user
USER ${NB_USER}

# Expose Jupyter port
EXPOSE 8888

# Default command (Binder will override this)
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]
