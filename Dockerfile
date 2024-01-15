FROM node:20.11.0-bookworm@sha256:9aa3de5470c99408fda002dc1f406e92a31daf0492eb33d857d8d9d252edcc52

LABEL org.opencontainers.image.description Update Cloudflare DNS with Docker container IP addresses.

WORKDIR /opt
COPY "package.json" "package.json"
COPY "output" "output"

CMD [ "/bin/bash", "-c", "node output/main.cjs" ]
