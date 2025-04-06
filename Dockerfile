# Use lightweight Alpine Linux as base
FROM alpine:latest

# Install required packages
RUN apk add --no-cache \
    bash \
    python3 \
    shadow \
    util-linux \
    coreutils \
    nano \
    sudo

# Create project directories
RUN mkdir -p /vos/{config,scripts,fs}

# Copy configuration files
COPY config/* /vos/config/
COPY scripts/* /vos/scripts/
COPY fs /vos/fs/

# Set up the initialization script
RUN chmod +x /vos/scripts/init.sh
ENTRYPOINT ["/vos/scripts/init.sh"]
