---
layout: project
title: Astro Substack
description: An Astro integration that backs up your free Substack posts as local Markdown and exposes them as a content collection.
links:
  - GitHub: https://github.com/syedmsawaid/astro-substack
  - npm: https://www.npmjs.com/package/@syedmsawaid/astro-substack
tech_stack:
  - TypeScript
  - Astro
  - Node.js
  - Turndown
launched: 2026
type: Library
state: Active
---

If Substack disappears, so does your newsletter. Astro Substack keeps a copy in your own repo. On every `astro dev` or `astro build` it fetches your publication's archive and writes each free post as a Markdown file with frontmatter, ready to use as an Astro content collection.

## Usage

Install it:

```sh
npm i @syedmsawaid/astro-substack
```

Add the integration with your publication name. A full `mypub.substack.com` address or a custom domain works too.

```js
// astro.config.mjs
import { defineConfig } from "astro/config";
import substack from "@syedmsawaid/astro-substack";

export default defineConfig({
  integrations: [substack({ publication: "mypub" })],
});
```

Register the collection:

```ts
// src/content.config.ts
import { substackCollection } from "@syedmsawaid/astro-substack/collection";

export const collections = { issues: substackCollection() };
```

Run `astro dev` or `astro build`, then use it like any other collection with `getCollection("issues")`. Commit `src/content/issues/` to git. That folder is your backup.

### Options

| Option | Default | Description |
|---|---|---|
| `publication` | required | `"mypub"`, `"mypub.substack.com"` or a custom domain |
| `dir` | `src/content/issues` | Output folder. Pass the same path to `substackCollection(dir)` |
| `downloadImages` | `true` | Download images next to the Markdown |
| `sync` | `true` | Set `false` to use only the local files |
| `force` | `false` | Re-download every post, even unchanged ones |
| `limit` | all | Only the newest N posts |
| `types` | `["newsletter"]` | Also `"podcast"` and `"thread"` |

Only free posts are backed up, since paid and subscriber-only posts are truncated previews. Image optimization needs `sharp` in your project, which is Astro's default. It supports Astro 5 and 6 on Node 18.20.8 or newer.

## How it works

The integration hooks into Astro's `astro:config:setup` step, so the sync runs before content collections load, on both `astro dev` and `astro build`.

1. **List the archive.** It pages through Substack's public JSON API (`/api/v1/archive`, 50 posts at a time) until a page comes back empty, then keeps only free posts of the types you asked for. Requests that hit a 429 or a 5xx are retried with exponential backoff.
2. **Skip what hasn't changed.** For each post it fetches the full post and compares Substack's `updated_at` with the `updatedAt` already stored in the local file's frontmatter. If they match, the post is skipped, so repeat builds are fast. Four posts are processed in parallel.
3. **Convert HTML to Markdown.** The post body goes through Turndown with the GFM plugin, plus custom rules. Subscribe buttons, share widgets and other Substack chrome are dropped. Images wrapped in links are unwrapped, captions become italics, and iframes are kept as plain links instead of vanishing.
4. **Localize images.** Substack serves images through a resizing CDN, with the original URL URL-encoded at the end of the path. The integration decodes that, downloads the original into `_images/<slug>/`, and rewrites the Markdown to a relative path, so Astro's image pipeline can optimize them. The cover image gets the same treatment.
5. **Write the file.** Each post lands at `<slug>.md` with frontmatter for title, subtitle, dates, canonical URL, cover image, tags, section and word count.

The `substackCollection()` helper wraps Astro's `glob` loader with a matching Zod schema, so `getCollection()` returns fully typed posts.

The sync never deletes anything. A post you remove or edit away on Substack stays in your backup, and if Substack is unreachable the integration logs a warning and the build carries on with your local copy.
