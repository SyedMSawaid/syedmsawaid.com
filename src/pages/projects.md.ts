import type { APIRoute } from "astro";

// Raw contents of every project write-up, frontmatter included.
const files = import.meta.glob<string>("/src/content/projects/*.{md,mdx}", {
  query: "?raw",
  import: "default",
  eager: true,
});

function launchedAt(raw: string) {
  const match = raw.match(/^launched:\s*(\d+)/m);
  return match ? Number(match[1]) : 0;
}

// Serves every project .md file, concatenated, at /projects.md.
export const GET: APIRoute = async () => {
  const sources = Object.entries(files)
    .map(([path, raw]) => ({ path, raw: raw.trim() }))
    .sort(
      (a, b) => launchedAt(b.raw) - launchedAt(a.raw) || a.path.localeCompare(b.path)
    );

  const body = sources
    .map(({ path, raw }) => `<!-- ${path.replace("/src/", "src/")} -->\n\n${raw}`)
    .join("\n\n");

  const markdown = `<!-- Generated from the projects on syedmsawaid.com. Don't edit this file; edit the source Markdown instead. -->\n\n${body}\n`;

  return new Response(markdown, {
    headers: { "Content-Type": "text/markdown; charset=utf-8" },
  });
};
