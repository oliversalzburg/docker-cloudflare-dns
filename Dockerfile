FROM node:22.4.0@sha256:2558f19e787cb0baed81a8068adf7509023b43dedce24ed606f8a01522b21313

LABEL org.opencontainers.image.description Update Cloudflare DNS with Docker container IP addresses.

WORKDIR /opt
COPY "package.json" "package.json"
COPY "output" "output"

CMD [ "/bin/bash", "-c", "node output/main.cjs" ]
