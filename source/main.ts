import http from "node:http";

const CLOUDFLARE_API_ENDPOINT = "https://api.cloudflare.com/client/v4";
// API key should be created with Edit permissions to target zone(s).
const CLOUDFLARE_API_KEY = process.env.CLOUDFLARE_API_KEY;

if (!CLOUDFLARE_API_KEY) {
  throw new Error("CLOUDFLARE_API_KEY is not set. Exiting.");
}

declare global {
  export const fetch: (
    url: string,
    options?: {
      body?: string;
      headers?: Record<string, string>;
      method?: "DELETE" | "GET" | "PATCH" | "POST";
    }
  ) => Promise<{ json(): Promise<Record<string, unknown>> }>;
}

type NetworkMetadata = {
  NetworkID: string;
  EndpointID: string;
  Gateway: string;
  IPAddress: string;
  IPPrefixLen: number;
  IPv6Gateway: string;
  GlobalIPv6Address: string;
  GlobalIPv6PrefixLen: number;
  MacAddress: string;
};

type ContainerMetadata = {
  Id: string;
  Names: Array<string>;
  Image: string;
  Labels: Record<string, string>;
  State: "running";
  Status: string;
  NetworkSettings: {
    Networks: Record<string, NetworkMetadata>;
  };
};

type CloudflareError = {
  code: number;
  message: string;
};

type ZoneInfo = { id: string; name: string };
type DnsRecord = {
  content: string;
  created_on: string;
  id: string;
  locked: boolean;
  modified_on: string;
  name: string;
  proxiable: boolean;
  proxied: boolean;
  ttl: number;
  type: "A" | "AAAA" | "CNAME";
};

const getContainers = () => {
  return new Promise<Array<ContainerMetadata>>((resolve, reject) => {
    const options = {
      socketPath: "/var/run/docker.sock",
      path: "/v1.26/containers/json",
      method: "GET",
    };

    const clientRequest = http.request(options, response => {
      response.setEncoding("utf8");
      let rawData = "";
      response.on("data", chunk => {
        rawData += chunk;
      });
      response.on("end", () => {
        const parsedData = JSON.parse(rawData) as Array<ContainerMetadata>;
        resolve(parsedData);
      });
    });
    clientRequest.on("error", e => {
      reject(e);
    });
    clientRequest.end();
  });
};

const getContainerIpAddress = (container: ContainerMetadata) => {
  const networks = Object.entries(container.NetworkSettings.Networks);
  if (networks.length < 1) {
    return null;
  }

  // Pick first network for now.
  const [, network] = networks[0];
  return {
    v4: network.IPAddress,
    v6: network.GlobalIPv6Address,
  };
};

let zonesCache: Array<ZoneInfo> | undefined;
const getZones = async () => {
  if (zonesCache) {
    return zonesCache;
  }

  const response = await fetch(`${CLOUDFLARE_API_ENDPOINT}/zones`, {
    headers: {
      Authorization: `Bearer ${CLOUDFLARE_API_KEY}`,
    },
  });
  const zones = await response.json();
  if (zones.success === false) {
    throw new Error((zones.errors as Array<CloudflareError>)[0].message);
  }
  zonesCache = zones.result as Array<ZoneInfo>;
  return zonesCache;
};

const zoneRecordsCache = new Map<string, Array<DnsRecord>>();
const getZoneRecords = async (zoneIdentifier: string) => {
  if (zoneRecordsCache.has(zoneIdentifier)) {
    return zoneRecordsCache.get(zoneIdentifier);
  }

  const response = await fetch(`${CLOUDFLARE_API_ENDPOINT}/zones/${zoneIdentifier}/dns_records`, {
    headers: {
      Authorization: `Bearer ${CLOUDFLARE_API_KEY}`,
    },
  });
  const records = await response.json();
  if (records.success === false) {
    throw new Error((records.errors as Array<CloudflareError>)[0].message);
  }

  const zoneRecords = records.result as Array<DnsRecord>;
  zoneRecordsCache.set(zoneIdentifier, zoneRecords);
  return zoneRecords;
};

const createRecord = async (
  zoneIdentifier: string,
  name: string,
  type: DnsRecord["type"],
  content: string
) => {
  const response = await fetch(`${CLOUDFLARE_API_ENDPOINT}/zones/${zoneIdentifier}/dns_records`, {
    body: JSON.stringify({
      type,
      name,
      content,
      ttl: 1,
    }),
    headers: {
      Authorization: `Bearer ${CLOUDFLARE_API_KEY}`,
    },
    method: "POST",
  });
  const records = await response.json();
  if (records.success === false) {
    throw new Error((records.errors as Array<CloudflareError>)[0].message);
  }
};
const deleteRecord = async (zoneIdentifier: string, identifier: string) => {
  const response = await fetch(
    `${CLOUDFLARE_API_ENDPOINT}/zones/${zoneIdentifier}/dns_records/${identifier}`,
    {
      headers: {
        Authorization: `Bearer ${CLOUDFLARE_API_KEY}`,
      },
      method: "DELETE",
    }
  );
  const records = await response.json();
  if (records.success === false) {
    throw new Error((records.errors as Array<CloudflareError>)[0].message);
  }
};
const updateRecord = async (zoneIdentifier: string, identifier: string, content: string) => {
  const response = await fetch(
    `${CLOUDFLARE_API_ENDPOINT}/zones/${zoneIdentifier}/dns_records/${identifier}`,
    {
      body: JSON.stringify({
        content,
      }),
      headers: {
        Authorization: `Bearer ${CLOUDFLARE_API_KEY}`,
      },
      method: "PATCH",
    }
  );
  const records = await response.json();
  if (records.success === false) {
    throw new Error((records.errors as Array<CloudflareError>)[0].message);
  }
};

const doesContainerUseCloudflareDns = (container: ContainerMetadata) => {
  const labels = Object.entries(container.Labels).find(([label]) => label === "cloudflare.enabled");
  return labels?.[1] === "true";
};

const getContainerCloudflareZone = (container: ContainerMetadata) => {
  const zoneLabel = Object.entries(container.Labels).find(([label]) => label === "cloudflare.zone");
  return zoneLabel?.[1];
};

const getContainerName = (container: ContainerMetadata) => {
  const nameLabel = Object.entries(container.Labels).find(([label]) => label === "cloudflare.name");
  if (nameLabel) {
    return nameLabel[1];
  }

  const name = container.Names[0].substring(1);
  console.info(
    `[${name}]: Container specifies no 'cloudflare.name' label, using default name '${name}'.`
  );
  return name;
};

const main = async () => {
  const zones = await getZones();

  const containers = await getContainers();
  for (const container of containers) {
    const containerName = getContainerName(container);

    if (!doesContainerUseCloudflareDns(container)) {
      console.debug(
        `[${containerName}]: Container is not configured for Cloudflare DNS. Set label 'cloudflare.enabled' to 'true' to enable.`
      );
      continue;
    }

    const zoneName = getContainerCloudflareZone(container);
    if (!zoneName) {
      console.error(
        `[${containerName}]: Container specifies no zone. Set label 'cloudflare.zone' to specify it.`
      );
      continue;
    }
    const zone = zones.find(subject => subject.name === zoneName);
    if (!zone) {
      console.error(`[${containerName}]: Container specifies invalid zone '${zoneName}'.`);
      continue;
    }

    const fqdn = `${containerName}.${zoneName}`;
    const records = await getZoneRecords(zone.id);
    const existingRecords = records?.filter(record => record.name === fqdn);
    let existingV4;
    let existingV6;

    if (!existingRecords || existingRecords.length < 1) {
      console.info(`[${containerName}]: No records for container exist yet.`);
    } else {
      existingV4 = existingRecords.find(record => record.type === "A");
      existingV6 = existingRecords.find(record => record.type === "AAAA");
    }

    const addresses = getContainerIpAddress(container);

    if (addresses?.v4) {
      if (existingV4) {
        if (existingV4.content === addresses.v4) {
          console.info(
            `[${containerName}]: Container DNS entry '${containerName}.${zoneName}' → '${existingV4.content}' (A) is up-to-date.`
          );
        } else {
          console.warn(
            `[${containerName}]: Container DNS entry '${containerName}.${zoneName}' → '${existingV4.content}' (A) will be changed to point to '${addresses.v4}'.`
          );
          await updateRecord(zone.id, existingV4.id, addresses.v4);
        }
      } else {
        console.warn(
          `[${containerName}]: Container DNS entry '${containerName}.${zoneName}' → '${addresses.v4}' (A) will be created.`
        );
        await createRecord(zone.id, fqdn, "A", addresses.v4);
      }
    } else if (existingV4) {
      console.warn(
        `[${containerName}]: Container DNS entry '${containerName}.${zoneName}' → '${existingV4.content}' (A) is no longer valid and will be removed!`
      );
      await deleteRecord(zone.id, existingV4.id);
    }

    if (addresses?.v6) {
      if (existingV6) {
        if (existingV6.content === addresses.v6) {
          console.info(
            `[${containerName}]: Container DNS entry '${containerName}.${zoneName}' → '${existingV6.content}' (AAAA) is up-to-date.`
          );
        } else {
          console.warn(
            `[${containerName}]: Container DNS entry '${containerName}.${zoneName}' → '${existingV6.content}' (AAAA) will be changed to point to '${addresses.v6}'.`
          );
          await updateRecord(zone.id, existingV6.id, addresses.v6);
        }
      } else {
        console.warn(
          `[${containerName}]: Container DNS entry '${containerName}.${zoneName}' → '${addresses.v6}' (AAAA) will be created.`
        );
        await createRecord(zone.id, fqdn, "AAAA", addresses.v6);
      }
    } else if (existingV6) {
      console.warn(
        `[${containerName}]: Container DNS entry '${containerName}.${zoneName}' → '${existingV6.content}' (AAAA) is no longer valid and will be removed!`
      );
      await deleteRecord(zone.id, existingV6.id);
    }
  }

  console.info("Operation completed.");
};

main().catch(console.error);
