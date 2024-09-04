FROM node:22.8.0@sha256:8ec02324cb37718197de92e51677781be9f1345c709f31a1f44440c6036d24a2

LABEL org.opencontainers.image.description Update Cloudflare DNS with Docker container IP addresses.

WORKDIR /opt
COPY "package.json" "package.json"
COPY "output" "output"

CMD [ "/bin/bash", "-c", "node output/main.cjs" ]
