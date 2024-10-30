FROM node:22.11.0@sha256:de4c8be8232b7081d8846360d73ce6dbff33c6636f2259cd14d82c0de1ac3ff2

LABEL "org.opencontainers.image.description"="Update Cloudflare DNS with Docker container IP addresses."

WORKDIR /opt
COPY "package.json" "package.json"
COPY "output" "output"

CMD [ "/bin/bash", "-c", "node output/main.cjs" ]
