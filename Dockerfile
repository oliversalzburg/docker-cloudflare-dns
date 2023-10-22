FROM node:18-buster@sha256:d31b6059279ce56d54cad940157daf0d6d7a44ed4cfaab06c23c09bc80469c03

LABEL org.opencontainers.image.description Update Cloudflare DNS with Docker container IP addresses.

WORKDIR /opt
COPY "package.json" "package.json"
COPY "output" "output"

CMD [ "/bin/bash", "-c", "node output/main.cjs" ]
