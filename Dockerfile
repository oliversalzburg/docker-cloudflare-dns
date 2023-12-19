FROM node:20.10.0-bookworm@sha256:c454cb8e4376ab2ac080eb5358ab4d4348a0e66da42886241f972348aa912daa

LABEL org.opencontainers.image.description Update Cloudflare DNS with Docker container IP addresses.

WORKDIR /opt
COPY "package.json" "package.json"
COPY "output" "output"

CMD [ "/bin/bash", "-c", "node output/main.cjs" ]
