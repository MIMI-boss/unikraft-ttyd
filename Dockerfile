# ttyd on Unikraft Cloud — Ubuntu 24.04 + ttyd 1.7.7 + network / sysadmin tools
# Rootfs is read-only (EROFS) on Unikraft: all tools must be baked in here.
# Writable space is the /data volume (512 MiB) mounted at deploy time.
FROM ubuntu:24.04

ARG TTYD_VERSION=1.7.7

RUN apt-get update && apt-get install -y --no-install-recommends \
      tini bash ca-certificates curl wget unzip \
      iproute2 iputils-ping procps net-tools dnsutils \
      vim tmux jq git openssh-client python3-minimal file less \
    && rm -rf /var/lib/apt/lists/* \
    && curl -fsSL -o /tmp/ttyd.x86_64 \
         "https://github.com/tsl0922/ttyd/releases/download/${TTYD_VERSION}/ttyd.x86_64" \
    && curl -fsSL -o /tmp/SHA256SUMS \
         "https://github.com/tsl0922/ttyd/releases/download/${TTYD_VERSION}/SHA256SUMS" \
    && cd /tmp && grep 'ttyd.x86_64' SHA256SUMS | sha256sum -c - \
    && install -m 0755 /tmp/ttyd.x86_64 /usr/local/bin/ttyd \
    && rm -f /tmp/ttyd.x86_64 /tmp/SHA256SUMS \
    && ttyd --version \
    && mkdir -p /data

COPY start-ttyd.sh /usr/local/bin/start-ttyd.sh
RUN chmod +x /usr/local/bin/start-ttyd.sh

WORKDIR /data
EXPOSE 7681

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["/usr/local/bin/start-ttyd.sh"]
