FROM node:22.9.0@sha256:cbe2d5f94110cea9817dd8c5809d05df49b4bd1aac5203f3594d88665ad37988

LABEL "org.opencontainers.image.description"="Update Cloudflare DNS with Docker container IP addresses."

WORKDIR /opt
COPY "package.json" "package.json"
COPY "output" "output"

CMD [ "/bin/bash", "-c", "node output/main.cjs" ]
