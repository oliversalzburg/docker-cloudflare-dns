FROM node:20.13.1-bookworm@sha256:45da3826d21df329eacade6725afa328442710e094454407151c42fef1341b0c

LABEL org.opencontainers.image.description Update Cloudflare DNS with Docker container IP addresses.

WORKDIR /opt
COPY "package.json" "package.json"
COPY "output" "output"

CMD [ "/bin/bash", "-c", "node output/main.cjs" ]
