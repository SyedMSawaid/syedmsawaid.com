// @ts-check
import { defineConfig } from 'astro/config';

import mdx from '@astrojs/mdx';
import tailwindcss from '@tailwindcss/vite';
import { load } from 'js-yaml';

// Lets `import data from "./file.yaml"` work by compiling YAML to an ES module.
function yaml() {
  return {
    name: 'yaml-import',
    transform(source, id) {
      const [path] = id.split('?');
      if (id.includes('?') || (!path.endsWith('.yaml') && !path.endsWith('.yml'))) return null;
      return { code: `export default ${JSON.stringify(load(source))};`, map: null };
    },
  };
}

// https://astro.build/config
export default defineConfig({
  site: 'https://syedmsawaid.com',
  integrations: [mdx()],
  vite: {
    plugins: [yaml(), tailwindcss()]
  }
});
