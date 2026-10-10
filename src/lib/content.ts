import type { CollectionEntry } from "astro:content";

export function publishedPosts(posts: CollectionEntry<"posts">[]) {
  return posts
    .filter((post) => post.data.published)
    .sort((a, b) => b.id.localeCompare(a.id));
}

export function postRoute(post: CollectionEntry<"posts">) {
  const match = post.id.replace(/\.mdx?$/, "").match(/^(\d{4})-(\d{2})-(\d{2})-(.+)$/);

  if (!match) {
    throw new Error(`Invalid post filename: ${post.id}`);
  }

  const [, year, month, day, slug] = match;
  return { year, month, day, slug, url: `/${year}/${month}/${day}/${slug}/` };
}

export function projectRoute(project: CollectionEntry<"projects">) {
  return `/projects/${project.id.replace(/\.md$/, "")}/`;
}

export function favoriteRoute(section: "watch" | "podcasts" | "books" | "people" | "blogs" | "articles", entry: { id: string }) {
  return `/favorite/${section}/${entry.id}/`;
}

export function formatPostDate(post: CollectionEntry<"posts">, format: "month" | "short" | "long") {
  const { year, month, day } = postRoute(post);
  const date = new Date(Date.UTC(Number(year), Number(month) - 1, Number(day)));
  const options: Intl.DateTimeFormatOptions = { timeZone: "UTC" };

  if (format === "month") {
    options.month = "short";
    options.year = "numeric";
  } else if (format === "short") {
    options.month = "short";
    options.day = "2-digit";
  } else {
    options.month = "long";
    options.day = "2-digit";
    options.year = "numeric";
  }

  return new Intl.DateTimeFormat("en-US", options).format(date);
}

export function readingTime(body: string) {
  const words = body.trim().split(/\s+/).filter(Boolean).length;
  return Math.max(1, Math.ceil(words / 200));
}
