FROM ubuntu:22.04

ARG BCC_VERSION="0.30.0"

ENV DEBIAN_FRONTEND=noninteractive

COPY root /

# Install dependencies
RUN set -x && \
    DISTRO=$(uname -r) && \
    export DEBIAN_FRONTEND=noninteractive && \
    UBUNTU_SYSTEM_PACKAGES_LIST=$(cat /ubuntu_system_packages.txt | tr '\n' ' ') && \
    apt-get update && \
    apt-get install -y ${UBUNTU_SYSTEM_PACKAGES_LIST} linux-headers-${DISTRO} && \
    apt-get autoclean && \
    apt-get --purge -y autoremove && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# compile bcc
RUN git clone https://github.com/iovisor/bcc.git && \
    cd bcc/ && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make && \
    make install && \
    cmake -DPYTHON_CMD=python3 .. && \
    cd src/python/ && \
    make && \
    make install && \
    rm -rf /bcc/