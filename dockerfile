# Use Debian 11 (Bullseye) as the base image
FROM debian:bullseye

# Set environment variables to prevent interactive prompts during apt-get
ENV DEBIAN_FRONTEND=noninteractive

# Update and install essential dependencies, Python, and pip
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    python3-venv \
    wget \
    git \
    curl \
    build-essential && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Upgrade pip and install JupyterLab and basic scientific Python libraries
RUN pip3 install --no-cache-dir --upgrade pip && \
    pip3 install --no-cache-dir \
    jupyterlab \
    ipykernel \
    numpy \
    pandas \
    matplotlib

# Expose the default Jupyter port (MyBinder expects the app to run on 8888)
EXPOSE 8888

# Set the command to start JupyterLab
# --allow-root is needed because custom Dockerfiles in Binder often run as root
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root", "--NotebookApp.token=''", "--NotebookApp.password=''"]
