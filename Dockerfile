FROM node:22.5.1@sha256:4c9ea09651a4939e37b15a4953d9ff8b5a038cfa949c77bb291b792d273b7239

LABEL org.opencontainers.image.description Update Cloudflare DNS with Docker container IP addresses.

WORKDIR /opt
COPY "package.json" "package.json"
COPY "output" "output"

CMD [ "/bin/bash", "-c", "node output/main.cjs" ]
