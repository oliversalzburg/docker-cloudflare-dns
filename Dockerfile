FROM node:22.8.0@sha256:bd00c03095f7586432805dbf7989be10361d27987f93de904b1fc003949a4794

LABEL org.opencontainers.image.description=Update Cloudflare DNS with Docker container IP addresses.

WORKDIR /opt
COPY "package.json" "package.json"
COPY "output" "output"

CMD [ "/bin/bash", "-c", "node output/main.cjs" ]
