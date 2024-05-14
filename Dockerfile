FROM node:20.13.1-bookworm@sha256:32834b043faec33925138c0f8fe5d6d2b2ba68eb14eb59e4f994dcadc95acf32

LABEL org.opencontainers.image.description Update Cloudflare DNS with Docker container IP addresses.

WORKDIR /opt
COPY "package.json" "package.json"
COPY "output" "output"

CMD [ "/bin/bash", "-c", "node output/main.cjs" ]
