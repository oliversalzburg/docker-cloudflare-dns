FROM node:20-buster@sha256:bc66c6d94ac2c0488fbff373b2a6cdff2f270bcec1eeaf468b3272d21ce5ac68

LABEL org.opencontainers.image.description Update Cloudflare DNS with Docker container IP addresses.

WORKDIR /opt
COPY "package.json" "package.json"
COPY "output" "output"

CMD [ "/bin/bash", "-c", "node output/main.cjs" ]
