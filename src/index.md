---
layout: default
---

Hi, I am **Syed Muhammad Sawaid.**

I am Software Engineer, Film Maker and an aspiring entrepreneur, currently based in beautiful town of Marburg, Germany.

I am doing Masters in Data Science from Philipps University Marburg.

In my free-time, I read, [write](posts), [code](software) and [film](film).

Here is my current software projects I am working on
- [Speak English](/software/speak-english)
- [see more](/software)

Here is the latest video I made
- [Building My Own Personal Portfolio Website](https://www.youtube.com/watch?v=YjgmT3Lmaqc)
- [see more](/film)

Here are some of my latest writings

{% for post in collections.posts.resources limit:3 %}
- ["{{ post.title }}"]({{ post.relative_url }})
{% endfor %}
- [read more](/posts)

I would love to hear from you. You can contact me:

- Email: me@SyedMSawaid.com
- Bluesky: [@syedmsawaid.com](https://bsky.app/profile/syedmsawaid.com){:target="_blank"}
- [other ways](/contact)