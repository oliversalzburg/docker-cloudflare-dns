FROM node:22.12.0@sha256:35a5dd72bcac4bce43266408b58a02be6ff0b6098ffa6f5435aeea980a8951d7

LABEL "org.opencontainers.image.description"="Update Cloudflare DNS with Docker container IP addresses."

WORKDIR /opt
COPY "package.json" "package.json"
COPY "output" "output"

CMD [ "/bin/bash", "-c", "node output/main.cjs" ]
