FROM debian:bullseye-slim

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

USER root
WORKDIR /app

# Install required packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    mysql-client && \
    ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Add MySQL client binaries to PATH
ENV PATH="/usr/bin:${PATH}"

# Copy the entrypoint script
COPY ./apps/mysql-init/entrypoint.sh /entrypoint.sh

# Make the script executable
RUN chmod +x /entrypoint.sh

# Set the entrypoint
ENTRYPOINT ["/usr/bin/catatonit", "--"]
CMD ["/entrypoint.sh"]
