---
layout: post
title:  Migrating to Bridgetown
date:   2024-03-02 20:43:48 +0500
tag:
  - blogging
  - writing
---

**TLDR: Nothing special here, got fed up of JS land and Vercel and moved to Bridgetown.**

The blogging platform for this website has changed more than the number of posts I have on website. First it started with Scully (a trashy Angular library), then I switched to Ghost (deployed on Fly), then it moved to Astro (deployed on Vercel) and now, it is finally migrating to Bridgetown which will be hosted on GitHub pages. This will be the final migration.

I started with Angular, because at the time, I was building my personal project with Angular and ASP.NET. For a simple static website, using Angular was an ungodly stupid choice. Generating simple HTML shouldn't be that hard, it should just work™. 

When I got fed up of the complexity of Angular and ASP.NET and all the communication between the two, I started learning Ruby on Rails. During that time, I stumbled on this wonderful [Ruby on Rails blog](https://www.writesoftwarewell.com/) run by [Akshay Khot](https://www.linkedin.com/in/akshaykhot03). Since I wanted a similar website for myself, I started using Ghost and deployed it on the freeplan on Fly. However, during this time, I published a couple of more arcticles, everything was going well until, one day, I got a email notification that my Fly website has crashed and restarted. And it became frequent (ofcourse, what you expect else do you expect from freeplan).

This time I also started watching Theo T3.gg. And I started using his sanctioned T3 stack to build my project. Since I have now already jumped into TS/JS land, I should just create my website in Astro. I also saw a couple of guys using Astro for their static websites so I jumped into it. [That's when I wrote this masterpiece (it's not).](https://syedmsawaid.com/2023/09/30/on-minimalism-and-launching-fast/)

Next.js didn't live up to my expectations. But we will talk about it some other day. But I switched back to Ruby on Rails and it was a delight to work with it. Now since I was fed up of Nextjs and Co., I have been looking for something easy.

And since I got into habit of reading articles, I stumbled on these two wonderful vlogs. One is by [Bèr Kessels](https://berk.es) and the other is [Tom MacWright](https://macwright.com/). I know for sure that Bèr Kessels used Jekyll since [his website is open-sourced](https://github.com/berkes/berkes.github.com), but looking at Tom's website URL pattern, it seems like he also used Jekyll ([Update: Yep, he did](https://macwright.com/2011/07/04/hello-internet)). These both websites have posts dating back like 2011. Damn, I want that sort of reliability.

I wanted to give Jekyll but I had bad experience with it. I have also tried [Sitepress](https://sitepress.cc/), but it was too slow for my liking (could be Windows). Looking for a new home for my blog, I stumbled on Bridgetown. The website seems cool. A couple of guys in Rails world are using it. And people on GoRails discord server seems to be liking it.

So I gave it a try, and to be honest, it really just works. Wanna use `.liquid`, `.erb` or any other templating engine? You can use it without any additional configuration.

There is this quote on Bridgetown's homepage and it couldn't be more true.
> Bridgetown is so cool. It’s the most fun I’ve had outside of Rails in a long time. [@_williamkennedy](https://twitter.com/_williamkennedy/status/1323023702502658049?s=21)

Bridgetown really is fun to work with. Thank you Bridgetown.

<details>
  <summary>Follow-ups & commmentary</summary>
  <ul>
    <li>Placeholder for the article I am gonna write left JS land  (p.s it's their ORMs)</li>
  </ul>
</details>