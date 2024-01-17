FROM node:20.11.0-bookworm@sha256:ffebb4405810c92d267a764b21975fb2d96772e41877248a37bf3abaa0d3b590

LABEL org.opencontainers.image.description Update Cloudflare DNS with Docker container IP addresses.

WORKDIR /opt
COPY "package.json" "package.json"
COPY "output" "output"

CMD [ "/bin/bash", "-c", "node output/main.cjs" ]
