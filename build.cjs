const esbuild = require("esbuild");

esbuild
  .build({
    entryPoints: ["./source/main.ts"],
    outfile: "./output/main.cjs",
    platform: "node",
    sourcemap: true,
    target: "node22",
    bundle: true,
  })
  .catch(console.error);
