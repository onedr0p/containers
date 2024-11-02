# Use an official CUDA runtime with Ubuntu as a parent image
FROM nvidia/cuda:12.1.0-runtime-ubuntu22.04

# Additional environment variables
ENV \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_ROOT_USER_ACTION=ignore \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_BREAK_SYSTEM_PACKAGES=1 \
    HOME="/app" \
    DEBIAN_FRONTEND=noninteractive

# Set umask and timezone
ENV UMASK="0002"

ENV TZ=Etc/UTC

USER root
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    ca-certificates \
    python3.11 \
    python3-pip \
    git \
    tzdata \
    && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
    && \
    rm -rf /var/lib/apt/lists/*

# Upgrade pip
RUN pip3 install --no-cache-dir --upgrade pip

# Clone the repository
RUN git clone https://github.com/theroyallab/tabbyAPI.git .

# Install packages specified in pyproject.toml cu121
RUN pip3 install --no-cache-dir .[cu121]

# Make port 5000 available to the world outside this container
EXPOSE 5000

# Set the entry point
ENTRYPOINT ["python3"]

# Run main.py when the container launches
CMD ["main.py"]

LABEL org.opencontainers.image.source="https://github.com/theroyallab/tabbyAPI"
