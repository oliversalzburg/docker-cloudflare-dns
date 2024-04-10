FROM node:20.12.1-bookworm@sha256:3b676479124ebdb0348f540e5c8b64f959ec1358cea05080b711d965f5353a34

LABEL org.opencontainers.image.description Update Cloudflare DNS with Docker container IP addresses.

WORKDIR /opt
COPY "package.json" "package.json"
COPY "output" "output"

CMD [ "/bin/bash", "-c", "node output/main.cjs" ]
