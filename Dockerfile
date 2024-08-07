FROM node:22.6.0@sha256:9ac0b68cc6512071449ebbff6f2a205471a390eb02be45f7ee2b3d887e25c18f

LABEL org.opencontainers.image.description Update Cloudflare DNS with Docker container IP addresses.

WORKDIR /opt
COPY "package.json" "package.json"
COPY "output" "output"

CMD [ "/bin/bash", "-c", "node output/main.cjs" ]
