import { defineCollection } from "astro:content";
import { glob } from "astro/loaders";
import { z } from "astro/zod";

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

const movies = defineCollection({
  loader: glob({ base: "./src/content/favorite/movies", pattern: "**/*.md" }),
  schema: z.object({
    title: z.string(),
    director: z.string().optional(),
    year: z.number().optional(),
    rating: z.number().min(0).max(5).optional(),
    url: z.url().optional(),
  }),
});

const podcasts = defineCollection({
  loader: glob({ base: "./src/content/favorite/podcasts", pattern: "**/*.md" }),
  schema: z.object({
    title: z.string(),
    show: z.string().optional(),
    year: z.number().optional(),
    url: z.url().optional(),
  }),
});

const books = defineCollection({
  loader: glob({ base: "./src/content/favorite/books", pattern: "**/*.md" }),
  schema: z.object({
    title: z.string(),
    author: z.string().optional(),
    year: z.number().optional(),
    rating: z.number().min(0).max(5).optional(),
    url: z.url().optional(),
  }),
});

const people = defineCollection({
  loader: glob({ base: "./src/content/favorite/people", pattern: "**/*.md" }),
  schema: z.object({
    name: z.string(),
    website: z.url().optional(),
  }),
});

const blogs = defineCollection({
  loader: glob({ base: "./src/content/favorite/blogs", pattern: "**/*.md" }),
  schema: z.object({
    title: z.string(),
    author: z.string().optional(),
    url: z.url().optional(),
  }),
});

const articles = defineCollection({
  loader: glob({ base: "./src/content/favorite/articles", pattern: "**/*.md" }),
  schema: z.object({
    title: z.string(),
    author: z.string().optional(),
    year: z.number().optional(),
    url: z.url().optional(),
  }),
});

export const collections = { posts, software, movies, podcasts, books, people, blogs, articles };
