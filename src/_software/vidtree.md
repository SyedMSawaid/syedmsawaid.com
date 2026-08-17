---
layout: project
title: VidTree
description: A native Go CLI that shows video runtimes and folder totals as a directory tree, without requiring FFmpeg.
links:
  - GitHub: https://github.com/syedmsawaid/vidtree
tech_stack:
  - Go
  - ISO Base Media
  - Matroska / EBML
  - GoReleaser
launched: 2026
type: CLI
state: Active
---

I wanted a quick way to answer a simple question: how much video runtime is inside this folder, and where is it distributed? VidTree scans a directory recursively and prints the answer as a tree, with durations and video counts aggregated for every folder.

It supports MP4, MOV, M4V, MKV, and WebM. Durations come directly from container metadata, so it doesn't decode video or shell out to FFmpeg, ffprobe, or any other external tool.

## Usage

```text
Videos/                               2h 13m 44s · 6 videos
├── Go Course/                        1h 31m 20s · 4 videos
│   ├── 01 Introduction.mp4               12m 08s
│   └── Concurrency/                      1h 00m 30s · 2 videos
└── Linux/                              42m 24s · 2 videos
```

The CLI can hide individual files, limit display depth, include hidden paths, sort by name, duration, or count, and produce plain or summary-only output. Display depth only changes what gets rendered; folder totals still include every scanned descendant.

## Implementation

Metadata probing runs through a bounded worker pool. Broken videos are reported without stopping the scan and never contribute to successful totals. File scanning, media probing, aggregation, sorting, and terminal rendering stay separate so other output formats can be added later without rewriting the scanner.

VidTree is a single native binary for Linux, macOS, and Windows. It can also be installed directly with Go:

```sh
go install github.com/syedmsawaid/vidtree@latest
```
