FROM node:22.3.0@sha256:a3816e038e05ea70d2640c845c285f49e416bdae2481a7ff94fde96647a10607

LABEL org.opencontainers.image.description Update Cloudflare DNS with Docker container IP addresses.

WORKDIR /opt
COPY "package.json" "package.json"
COPY "output" "output"

CMD [ "/bin/bash", "-c", "node output/main.cjs" ]
