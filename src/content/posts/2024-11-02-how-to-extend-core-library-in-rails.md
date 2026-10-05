---
layout: post
title:  How to extend core library in Rails
date:   2024-11-02 18:32:48 +0100
tags:
- Ruby on Rails
- Tutorial
---

If you have ever worked with Ruby on Rails, you will quickly find that a lot of methods are added to the standard library. We don’t have methods such as  `humanize` or `tableize`  on `String`  when working with vanilla ruby. If you have ever played with Ruby outside the Rails ecosystem, you will quickly find out that the methods you took for granted in Rails doesn’t exist in vanilla Ruby.

Ruby on Rails add fluency to your code through extending these core classes like Date and String. This way, you get a smooth and fluent interface when working with these classes that resemble English language. In C#, you will have partial classes and extension methods to support this. However, for partial classes, you have to add the keyword `partial` to the class declaration. For core classes such as `String`, you can’t do that. The only way left to do it is through extension methods, but they aren’t part of the class definition itself. In Ruby, you can open a class anywhere you like as long as it is namespaced correctly.

Another thing you might have found strange in Ruby on Rails is that you aren’t required to `import` or `require` any file when using it. That’s because it autoload them on application start (or restart) and make them available throughout the application. Ruby on Rails uses [Zeitwerk](https://github.com/fxn/zeitwerk) to achieve this.

To extend a core class, add a file like `string.rb` to `lib/core_ext` folder. The folder name `core_ext` is not important, it is more of a convention. Add any class there that you want to extend. For this example, we are going to extend the `String` class.

```ruby
# lib/core_ext/string.rb
class String
  def valid_date?
    splitted = split "-"
    return false if splitted.count != 3

    year, month, day = splitted.map(&:to_i)
    return Date.valid_date? year, month, day
  end
end
```

You can add here as many files or classes as you like to `core_ext`. But for our case, we will go with `String`.

Next, add another file to `config/initializers` folder. Name it `core_ext.rb` to indicate what this initializer does. The code inside the `initializer` runs on every start up before the application code. This is the place to add all the things we want to do on startup, such as adding different renderers, mime types.

Add this code to the `config/initializers/core_ext.rb` file.

```ruby
# config/initializers/core_ext.rb

Dir[File.join(Rails.root, "lib", "core_ext", "**", "*.rb")].each do |file|
  require file
end

Rails.autoloaders.main.tap do |loader|
  loader.collapse(File.join(Rails.root, "lib", "core_ext"))
end
```

The `Dir[File.join(Rails.root, "lib", "core_ext", "**", "*.rb")]` returns list of path of all the `.rb` files from `lib/core_ext`. Next we iterate over each file path and `require` them like you `require` any other file in ruby.

Since Rails is using Zeitwerk, it has its own gotchas.

Zeitwerk automatically add namespaces to the files it loads. If a file is inside `lib/core_ext/string.rb`, it will namespace it as `Lib::CoreExt::String`. This is its default behavior. Since we don’t have `Lib` or `CoreExt` module, it will throw an error when you start you rails server. Even if you do have these modules, you still won’t be able to add your methods to the core class since their signature is different. For finer control on how the files are loaded with Zeitwerk, it has a method to collapse folder when autoloading, `lib/core_ext/string.rb` will be loaded as `String` rather than `Lib::CoreExt::String`.

That’s what we do in the second part of the code. We tap into the main autoloader for Rails through `Rails.autoloaders.main.tap` and then we collapse the `lib/core_ext` folder. This way, when we do load the files from `lib/core_ext`, it open those core ruby classes and add methods to it.

Now, you can openly use your new methods everywhere in Rails application by calling it. For this example, we can call it by `“2022-01-01”.valid_date?`.