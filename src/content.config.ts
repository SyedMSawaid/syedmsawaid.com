import { defineCollection, z } from "astro:content";
import { glob } from "astro/loaders";

const posts = defineCollection({
  loader: glob({ base: "./src/content/posts", pattern: "**/*.{md,mdx}" }),
  schema: z.object({
    layout: z.string().optional(),
    title: z.string(),
    date: z.coerce.date(),
    published: z.boolean().default(true),
    tags: z.array(z.string()).nullish(),
  }),
});

const software = defineCollection({
  loader: glob({ base: "./src/content/software", pattern: "**/*.md" }),
  schema: z.object({
    layout: z.string().optional(),
    title: z.string(),
    description: z.string(),
    links: z.array(z.record(z.string(), z.string())).nullish(),
    tech_stack: z.array(z.string()).default([]),
    launched: z.number(),
    type: z.string(),
    state: z.string().optional(),
  }),
});

export const collections = { posts, software };
