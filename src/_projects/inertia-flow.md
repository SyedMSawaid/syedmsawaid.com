---
layout: project
title: Inertia Flow
description: Extension library for Inertia-Rails
github: https://github.com/syedmsawaid/inertia_flow
url: https://github.com/syedmsawaid/inertia_flow
tech_stack:
  - Ruby
  - Rails
  - Inertia.js
launched: 2024
---

Inertia Flow moves prop building from controllers folder to views folder keeping the controllers clean and slim.

The official inertia adaptor for rails “Inertia_rails” allows passing props to inertia view using instance variables of the controller like @posts . But if you have to change and process your props, you have to do that within the controller, model or a model serializer.

Inertia Flow uses jbuilder to move this logic from controller to views.

Instead of building your props in the controller, you move them to views with files like index.inertia.jbuilder.
