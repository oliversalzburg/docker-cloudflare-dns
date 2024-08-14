FROM node:22.6.0@sha256:914458d8617650599ec2c05f6754403a1ce08cb471b0b1de1de439c539f8d45f

LABEL org.opencontainers.image.description Update Cloudflare DNS with Docker container IP addresses.

WORKDIR /opt
COPY "package.json" "package.json"
COPY "output" "output"

CMD [ "/bin/bash", "-c", "node output/main.cjs" ]
