FROM node:22.5.1@sha256:41a78fa18185639ae24f9148980ebf9d69c0a1463848f691b7b1265e86778f1a

LABEL org.opencontainers.image.description Update Cloudflare DNS with Docker container IP addresses.

WORKDIR /opt
COPY "package.json" "package.json"
COPY "output" "output"

CMD [ "/bin/bash", "-c", "node output/main.cjs" ]
