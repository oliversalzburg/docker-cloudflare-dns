FROM node:22.5.0@sha256:b44cbfafe84144217b7502cde5d21958500781fb9b13eed74a47486db2277cd5

LABEL org.opencontainers.image.description Update Cloudflare DNS with Docker container IP addresses.

WORKDIR /opt
COPY "package.json" "package.json"
COPY "output" "output"

CMD [ "/bin/bash", "-c", "node output/main.cjs" ]
