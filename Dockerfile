FROM node:22.6.0@sha256:4d5f1ea97f86073ce02322afd1add0bd5899ac4fa0deec4f7f91229f645da067

LABEL org.opencontainers.image.description Update Cloudflare DNS with Docker container IP addresses.

WORKDIR /opt
COPY "package.json" "package.json"
COPY "output" "output"

CMD [ "/bin/bash", "-c", "node output/main.cjs" ]
