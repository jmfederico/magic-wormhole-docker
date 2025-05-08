FROM opensuse/tumbleweed

# Refresh repositories and install

RUN zypper refresh && \
    zypper install -y magic-wormhole.rs && \
    zypper clean --all

# Set the working directory
WORKDIR /data

# Set the entrypoint
ENTRYPOINT ["wormhole-rs"]
