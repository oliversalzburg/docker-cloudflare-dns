FROM node:22.13.0@sha256:40500dee24186ae165e667b219de8a1757c00f2cdecf7ea552fc1cd1b66a842b

LABEL "org.opencontainers.image.description"="Update Cloudflare DNS with Docker container IP addresses."

WORKDIR /opt
COPY "package.json" "package.json"
COPY "output" "output"

CMD [ "/bin/bash", "-c", "node output/main.cjs" ]
