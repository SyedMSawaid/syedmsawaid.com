require "bridgetown"

Bridgetown.load_tasks

# Run rake without specifying any command to execute a deploy build by default.
task default: :deploy

#
# Standard set of tasks, which you can customize if you wish:
#
desc "Build the Bridgetown site for deployment"
task :deploy => [:clean, "frontend:build"] do
  Bridgetown::Commands::Build.start
end

desc "Build the site in a test environment"
task :test do
  ENV["BRIDGETOWN_ENV"] = "test"
  Bridgetown::Commands::Build.start
end

desc "Runs the clean command"
task :clean do
  Bridgetown::Commands::Clean.start
end

namespace :frontend do
  desc "Build the frontend with esbuild for deployment"
  task :build do
    sh "touch frontend/styles/jit-refresh.css"
    sh "yarn run esbuild"
  end

  desc "Watch the frontend with esbuild during development"
  task :dev do
    sh "touch frontend/styles/jit-refresh.css"
    sh "yarn run esbuild-dev"
  rescue Interrupt
  end
end

#
# Add your own Rake tasks here! You can use `environment` as a prerequisite
# in order to write automations or other commands requiring a loaded site.
#
# task :my_task => :environment do
#   puts site.root_dir
#   automation do
#     say_status :rake, "I'm a Rake tast =) #{site.config.url}"
#   end
# end

# bundle exec rake create post "My New Post"
desc "Create a new resource"
task :create do |task|
  rake_task, type, title = ARGV
  time = Time.now

  folder_name = folder_name_for type
  file_name = file_name_for title, at: time
  file_path = "#{folder_name}/#{file_name}.md"


  abort "A post with \"#{file_path}\" and title \"#{title}\" already exists".red if File.exist? file_path

  File.open file_path, "w" do |file|
    file.write file_content type: type, title: title, at: time
  end

  puts "Successfully created a post at \"#{file_path}\" with title \"#{title}\".".green
  exit
end

private

def folder_name_for type
  "src/_#{type.pluralize}"
end

def file_name_for title, at:
  "#{at.to_date}-#{title.parameterize}"
end

def file_content type:, title:, at:
  %(---
layout: #{type}
title:  #{title}
date:   #{at}
tags:
---
)
end
