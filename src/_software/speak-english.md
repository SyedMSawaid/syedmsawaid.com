---
layout: project
title: Speak English
description: A shadowing app that plays YouTube video snippets for pronunciation practice, with real-time remote playback control via WebSockets.
links:
tech_stack:
  - Ruby
  - Rails
  - Hotwire
  - WebSockets
  - Madmin
launched: 2025
type: SaaS
state: Inactive
---

Shadowing is one of the most effective ways to improve spoken English. You listen to a native speaker, then immediately repeat what they said, matching the rhythm, stress, and pronunciation. The problem is finding good material and looping specific moments without constantly scrubbing a video player.

Speak English made that frictionless. It pulled snippets from YouTube videos and surfaced them one at a time, so you could listen and shadow without distraction.

The playback was controlled remotely via WebSockets. Since shadowing works best when you're standing up and speaking out loud, the app let me control everything from my phone. No walking back to the desk to hit play again.

An admin panel built with Madmin handled the content side: adding videos, curating snippets, and managing the queue.