FROM node:20.1.0-bookworm@sha256:b2d2b808d77a42db2a7b6b85a3dc25ce014550d98b894556e642c0a88ab40b25

LABEL org.opencontainers.image.description Update Cloudflare DNS with Docker container IP addresses.

WORKDIR /opt
COPY "package.json" "package.json"
COPY "output" "output"

CMD [ "/bin/bash", "-c", "node output/main.cjs" ]
