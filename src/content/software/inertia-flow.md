---
layout: project
title: Inertia Flow
description: Moves Inertia prop building out of controllers and into view files, keeping your Rails controllers clean.
links:
- GitHub: https://github.com/syedmsawaid/inertia_flow
- RubyGems: https://rubygems.org/gems/inertia_flow
tech_stack:
  - Ruby
  - Rails
  - Inertia.js
launched: 2024
type: Library
state: Active
---

The official `inertia-rails` adapter passes props via controller instance variables like `@posts`. Simple enough, but any prop shaping or transformation has to happen somewhere in the controller, model, or a serializer, pulling logic into places it doesn't belong.

Inertia Flow introduces a view layer for props. Using jbuilder, you define your props in dedicated view files like `index.inertia.jbuilder`, keeping controllers thin and prop logic co-located with the view it serves.

## Without Inertia Flow

The controller handles both fetching and shaping data:

```ruby
# app/controllers/posts_controller.rb
def index
  @posts = Post.published

  render inertia: "Posts/Index", props: {
    posts: @posts.map do |post|
      {
        id: post.id,
        title: post.title,
        author: post.author.name,
        excerpt: post.body.truncate(120)
      }
    end
  }
end
```

## With Inertia Flow

The controller just fetches:

```ruby
# app/controllers/posts_controller.rb
def index
  @posts = Post.published

  respond_to do |format|
    format.inertia
  end
end
```

And a view file handles the shape:

```ruby
# app/views/posts/index.inertia.jbuilder
json.posts @posts do |post|
  json.id post.id
  json.title post.title
  json.author post.author.name
  json.excerpt post.body.truncate(120)
end
```
