FROM node:20.12.2-bookworm@sha256:1de802fdf24ea1b1b5dddb5bbd17049708e61226c9753879360d056298fd5c66

LABEL org.opencontainers.image.description Update Cloudflare DNS with Docker container IP addresses.

WORKDIR /opt
COPY "package.json" "package.json"
COPY "output" "output"

CMD [ "/bin/bash", "-c", "node output/main.cjs" ]
