FROM node:22.3.0@sha256:f73cc32c7285fba333cc4fbe00d5ff8babf7ebfa6a2557ab22919bcfdff05f0e

LABEL org.opencontainers.image.description Update Cloudflare DNS with Docker container IP addresses.

WORKDIR /opt
COPY "package.json" "package.json"
COPY "output" "output"

CMD [ "/bin/bash", "-c", "node output/main.cjs" ]
