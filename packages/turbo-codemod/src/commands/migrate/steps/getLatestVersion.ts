import axios from "axios";

import type { MigrateCommandOptions } from "../types";

const REGISTRY = "https://registry.npmjs.org";

async function getPackageDetails({ packageName }: { packageName: string }) {
  try {
    const result = await axios.get(`${REGISTRY}/${packageName}`);
    return result.data;
  } catch (err) {
    throw new Error(`Unable to fetch the latest version of ${packageName}`);
  }
}

export default async function getLatestVersion({
  to,
}: MigrateCommandOptions): Promise<string | undefined> {
  const packageDetails = await getPackageDetails({ packageName: "turbo" });
  const versions = packageDetails["dist-tags"];

  if (to) {
    if (packageDetails[to]) {
      return to;
    } else {
      throw new Error(`turbo@${to} does not exist`);
    }
  }

  return versions.latest as string;
}
