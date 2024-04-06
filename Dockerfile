FROM node:20.12.1-bookworm@sha256:8a03de2385cb16c4d76aac30bf86ab05f55f1754a5402dc9039916e8043f019a

LABEL org.opencontainers.image.description Update Cloudflare DNS with Docker container IP addresses.

WORKDIR /opt
COPY "package.json" "package.json"
COPY "output" "output"

CMD [ "/bin/bash", "-c", "node output/main.cjs" ]
