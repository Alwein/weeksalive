import type { NextConfig } from "next";
import path from "path";
import { fileURLToPath } from "url";

const dir = path.dirname(fileURLToPath(import.meta.url));

const nextConfig: NextConfig = {
  reactStrictMode: true,
  outputFileTracingRoot: dir,
  images: {
    // Firebase Hosting blocks /_next/image; serve public assets directly.
    unoptimized: true,
  },
};

export default nextConfig;
