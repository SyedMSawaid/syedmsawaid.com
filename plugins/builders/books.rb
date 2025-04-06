# frozen_string_literal: true
class Builders::Books < SiteBuilder
  def initialize(name = nil, current_site = nil)
    super
    @books = []
  end

  def build
    generator do
      create_book_objects
      generate_books
    end
  end

  def create_book_objects
    site.collections.books.resources
        .group_by { |b| b.id.split("_books/").last.split("/").first }
        .each do |book_id, chapters|
          resource = add_resource(:book, "books/#{book_id}.md") { permalink "/books/:slug/" }
          @books << Book.new(resource, chapters: chapters)
        end
  end

  def generate_books
    @books.each(&:generate)
  end
end

# noinspection ALL
class Book
  attr_accessor :name, :resource, :chapters
  delegate :id, to: :resource
  alias_method :title, :name

  def initialize(book, chapters:)
    @resource = book
    @chapters = []
    @name = slug.titleize

    chapters.each do |chapter|
      @chapters << Chapter.new(chapter, self)
    end
  end

  def slug
    id.split("/").last.split(".md").first
  end

  def link
    resource.relative_url
  end

  def generate
    resource.data.layout = :book
    resource.data.title = title
    resource.content = content

    chapters.each(&:generate)
  end

  def content
    <<-HTML
<ul data-controller="bookmark" data-bookmark-chapter-outlet='.chapter' data-bookmark-book-value="#{slug}">
 #{chapters.map { |chapter|
      "<li class='chapter' data-controller='chapter' data-chapter-id-value='#{chapter.id}'>
        <a href='#{chapter.link}'>#{chapter.title}</a>
        <div>your mom</div>
        <div data-chapter-target='bookmark'></div>
       </li>"
    }.join }
</ul>
    HTML
  end
end

# noinspection ALL
class Chapter
  attr_accessor :name, :slug, :resource, :book
  delegate :id, :data, to: :resource

  def initialize(chapter, book)
    @resource = chapter
    @book = book
  end

  def link
    resource.relative_url
  end

  def title
    data.title
  end

  def next_chapter
    book.chapters[book.chapters.index(self) + 1]
  end

  def generate
    resource.data.layout = "chapter"
    resource.data.book_title = book.name
    resource.data.book_link = book.link
    resource.data.next_chapter_title = next_chapter&.title
    resource.data.next_chapter_link = next_chapter&.link
    resource.content = <<-HTML
#{resource.content}
<div data-controller="reading"
     data-reading-id-value="#{id}"
     data-reading-book-value="#{id.split("_books/").last.split("/").first}">
</div>
HTML
  end
end