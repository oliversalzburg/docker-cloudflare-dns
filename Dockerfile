FROM node:20.12.1-bookworm@sha256:d1b84e4aa4b90f6bb9640d87bd5e45ed4f79f782fb00ee7c62e72dfcedfa2f62

LABEL org.opencontainers.image.description Update Cloudflare DNS with Docker container IP addresses.

WORKDIR /opt
COPY "package.json" "package.json"
COPY "output" "output"

CMD [ "/bin/bash", "-c", "node output/main.cjs" ]
