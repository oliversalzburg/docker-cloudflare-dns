FROM node:20.12.2-bookworm@sha256:ec31b4e7762901e0a1cbf5a82ffd66c9798057c50f1b6f33a0089cf0bbbcffed

LABEL org.opencontainers.image.description Update Cloudflare DNS with Docker container IP addresses.

WORKDIR /opt
COPY "package.json" "package.json"
COPY "output" "output"

CMD [ "/bin/bash", "-c", "node output/main.cjs" ]
