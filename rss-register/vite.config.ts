import { crx, defineManifest } from "@crxjs/vite-plugin";
import { defineConfig } from "vite";
import { nodePolyfills } from "vite-plugin-node-polyfills";

const manifest = defineManifest({
  manifest_version: 3,
  description: "rss register",
  name: "rss register",
  version: "0.1.0",
  icons: {
    128: "icons/icon128.png",
  },
  action: {
    default_icon: "icons/icon128.png",
    default_title: "rss register",
  },
  background: {
    service_worker: "src/background/index.ts",
  },
  permissions: ["activeTab"],
});

export default defineConfig({
  plugins: [crx({ manifest }), nodePolyfills()],
  build: {
    sourcemap: true,
  },
});
