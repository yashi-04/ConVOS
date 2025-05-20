
# # lightweight Alpine Linux as base
# FROM alpine:latest

# # Install required packages (grouped logically)
# RUN apk add --no-cache expect \
#     # Shell and core utilities
#     bash \
#     coreutils \
#     util-linux \
#     # Required for password hashing
#     openssl \
#     # User management
#     shadow \
#     sudo \
#     # Editors and tools
#     nano \
#     # Programming language
#     python3 \
#     # Monitoring/management
#     htop \
#     # Network utilities
#     curl \
#     wget

# # Create project directory structure
# RUN mkdir -p /vos/{config,scripts,fs/{etc,var,home}}

# # Copy configuration files (preserving permissions)
# COPY --chmod=644 config/* /vos/config/
# COPY --chmod=755 scripts/* /vos/scripts/
# COPY --chmod=755 fs /vos/fs/

# # Verify critical scripts exist
# RUN test -f /vos/scripts/init.sh && \
#     test -f /vos/scripts/login.sh && \
#     test -f /vos/scripts/setup_environment.sh

# # Set up the initialization script
# RUN chmod +x /vos/scripts/init.sh

# WORKDIR /vos
# ENTRYPOINT ["/vos/scripts/init.sh"]

ROM alpine:latest

RUN apk add --no-cache expect bash coreutils util-linux openssl shadow sudo nano python3 htop curl wget

RUN mkdir -p /vos/{config,scripts,fs/{etc,var,home}}

COPY --chmod=644 config/* /vos/config/
COPY --chmod=755 scripts/* /vos/scripts/
COPY --chmod=755 fs /vos/fs/

RUN test -f /vos/scripts/init.sh && \
    test -f /vos/scripts/login.sh && \
    test -f /vos/scripts/setup_environment.sh

RUN chmod +x /vos/scripts/init.sh

WORKDIR /vos

#  Create the 'admin' user.  The important thing is that this is done *before* the USER instruction.
RUN adduser -D -u 1000 -g 1000 admin

#  Ensure that the container runs as the 'admin' user by default.
USER admin

#  The init.sh script will run as root, but the container will switch to non-root after it is done.
CMD ["/vos/scripts/init.sh"]
