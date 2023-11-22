FROM node:20.9.0-bookworm@sha256:146bbe4eaee99ae885be2a0a767f63a4b96032141d70d80e590f10e0d7ebabcb

LABEL org.opencontainers.image.description Update Cloudflare DNS with Docker container IP addresses.

WORKDIR /opt
COPY "package.json" "package.json"
COPY "output" "output"

CMD [ "/bin/bash", "-c", "node output/main.cjs" ]
