---
layout: project
title: Detawk
description: A German language learning platform built around the FSI Basic German Course, with AI-generated audio and card-based drills.
links:
  - App: https://detawk.com
tech_stack:
  - Ruby on Rails
  - Hotwire
  - SQLite
  - ElevenLabs
  - Stripe
  - Kamal
launched: 2026
type: SaaS
state: Active
---

The FSI Basic German Course is a public domain course made by the US government. It's one of the better resources out there for learning German, but it's a PDF. I built Detawk to make it interactive.

It covers all 24 units with 9 drill types. Cards hide the answer until you reveal it, then audio plays automatically. Every word and sentence has audio at normal and slow speed, generated via ElevenLabs and manually reviewed before going live. Fully keyboard navigable. Subscription-based.

## Stack

Rails 8.1, Hotwire, no JS framework, no bundler. SQLite for everything: database, jobs (Solid Queue), cache (Solid Cache), WebSockets (Solid Cable). No Redis, no Sidekiq. Auth via Devise and Google OAuth. Payments via Stripe.

Deployed with Kamal. Litestream replicates the database to Backblaze B2. Madmin for content, Mission Control for jobs, PostHog for analytics, Honeybadger for errors.
