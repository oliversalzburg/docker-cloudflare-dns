FROM node:22.3.0@sha256:5e4044ff6001d06e7748e35bfa4f80c73cf5f5a7360a1b782995e038a01b0585

LABEL org.opencontainers.image.description Update Cloudflare DNS with Docker container IP addresses.

WORKDIR /opt
COPY "package.json" "package.json"
COPY "output" "output"

CMD [ "/bin/bash", "-c", "node output/main.cjs" ]
