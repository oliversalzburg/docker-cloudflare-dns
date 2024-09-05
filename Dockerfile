FROM node:22.8.0@sha256:7cbc7e41c78f055826a9e2498ecac951fdbc1b0cc3b5d70e7ee5d57189a9de41

LABEL org.opencontainers.image.description Update Cloudflare DNS with Docker container IP addresses.

WORKDIR /opt
COPY "package.json" "package.json"
COPY "output" "output"

CMD [ "/bin/bash", "-c", "node output/main.cjs" ]
