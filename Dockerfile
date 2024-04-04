FROM node:20.12.1-bookworm@sha256:378e7b82c3846dd5cf2df24f54f51cf9fa0ca4771963609ff9b60f7ca8bbbd2b

LABEL org.opencontainers.image.description Update Cloudflare DNS with Docker container IP addresses.

WORKDIR /opt
COPY "package.json" "package.json"
COPY "output" "output"

CMD [ "/bin/bash", "-c", "node output/main.cjs" ]
