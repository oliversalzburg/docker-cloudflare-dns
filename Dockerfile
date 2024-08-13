FROM node:22.6.0@sha256:27649827e47190ea8c7db5601a980abcaf5b7e2d66a2a186856ddd36c8dde5b5

LABEL org.opencontainers.image.description Update Cloudflare DNS with Docker container IP addresses.

WORKDIR /opt
COPY "package.json" "package.json"
COPY "output" "output"

CMD [ "/bin/bash", "-c", "node output/main.cjs" ]
