FROM node:22.3.0@sha256:b98ec1c96103fbe1a9e449b3854bbc0a0ed1c5936882ae0939d4c3a771265b4b

LABEL org.opencontainers.image.description Update Cloudflare DNS with Docker container IP addresses.

WORKDIR /opt
COPY "package.json" "package.json"
COPY "output" "output"

CMD [ "/bin/bash", "-c", "node output/main.cjs" ]
