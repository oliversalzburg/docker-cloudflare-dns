FROM node:20-buster@sha256:4f32caeadd6d027f531b7420a27e694381824c9cf14a8abfe16771e6023ee8c0

LABEL org.opencontainers.image.description Update Cloudflare DNS with Docker container IP addresses.

WORKDIR /opt
COPY "package.json" "package.json"
COPY "output" "output"

CMD [ "/bin/bash", "-c", "node output/main.cjs" ]
