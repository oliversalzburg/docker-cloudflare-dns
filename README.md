# docker-cloudflare-dns

Updates CloudFlare DNS with IP addresses of running Docker containers.

## Usage

`CLOUDFLARE_API_KEY` needs to have `Edit` permissions for all zones that you want to maintain.

```shell
docker run --rm --name cloudflare-dns \
    --volume /var/run/docker.sock:/var/run/docker.sock:ro \
    --env "CLOUDFLARE_API_KEY=<your API key here>" \
    ghcr.io/oliversalzburg/docker-cloudflare-dns:v0.0.6
```

Output will guide you from there, if anything is wrong.

### Labels

Behavior is controlled through container labels:

| Label                  | Required | Description                                                     |
| ---------------------- | -------- | --------------------------------------------------------------- |
| `'cloudflare.enabled'` | yes      | Set to `'true'` to include this container in DNS updates.       |
| `'cloudflare.zone'`    | yes      | Specifies the zone in your CloudFlare account to update.        |
| `'cloudflare.name'`    | no       | Override the record name. Default is the name of the container. |

## Example

```shell
docker run --rm --name traefik \
    --publish "8080:8080" \
    --volume /var/run/docker.sock:/var/run/docker.sock:ro \
    --label "cloudflare.enabled=true" \
    --label "cloudflare.name=ingress" \
    --label "cloudflare.zone=example.com" \
    traefik:latest \
    --api.insecure=true \
    --providers.docker=true \
    --providers.docker.exposedByDefault=false
```

## Release Process

```
npm version patch --message "chore: Version bump %s"
```
