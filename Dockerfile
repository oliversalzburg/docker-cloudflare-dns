FROM node:22.5.1@sha256:86915971d2ce1548842315fcce7cda0da59319a4dab6b9fc0827e762ef04683a

LABEL org.opencontainers.image.description Update Cloudflare DNS with Docker container IP addresses.

WORKDIR /opt
COPY "package.json" "package.json"
COPY "output" "output"

CMD [ "/bin/bash", "-c", "node output/main.cjs" ]
