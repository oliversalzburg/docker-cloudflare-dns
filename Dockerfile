FROM node:20.10.0-bookworm@sha256:445acd9b2ef7e9de665424053bf95652e0b8995ef36500557d48faf29300170a

LABEL org.opencontainers.image.description Update Cloudflare DNS with Docker container IP addresses.

WORKDIR /opt
COPY "package.json" "package.json"
COPY "output" "output"

CMD [ "/bin/bash", "-c", "node output/main.cjs" ]
