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
      @chapters << Chapter.new(chapter, book: self)
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
      li chapter
    }.join }
</ul>
    HTML
  end

  def li(chapter)
    <<-HTML
<li class='chapter flex justify-between items-end gap-4'
    data-controller='chapter'
    data-chapter-id-value='#{chapter.id}'
    data-chapter-ellipsis-class="text-orange-500"
    data-chapter-bookmark-class="fill-orange-500 w-8 px-0.5"
>
  <a href='#{chapter.link}' class="text-nowrap">#{chapter.title}</a>
  <span class="grow overflow-hidden text-sm" data-chapter-target="ellipsis">............................................................................................................................................................................................................................................................................................................................................................................................................</span>
  <span class="text-nowrap">#{chapter.word_count}</span>
</li>
HTML
  end
end

# noinspection ALL
class Chapter
  attr_accessor :name, :slug, :resource, :book, :word_count
  delegate :id, :data, to: :resource

  def initialize(chapter, book:)
    @resource = chapter
    @book = book

    # Populate the word count before adding the stimulus controller
    calculate_word_count
  end

  def calculate_word_count
    words_array = resource.content.split - %w[ # ]
    @word_count = words_array.size
  end

  def delimited_word_count
    @word_count.to_fs(:delimited)
  end

  def word_count
    return "#{delimited_word_count} words" if @word_count > 1
    return "#{delimited_word_count} word"
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
    resource.data.word_count = word_count
    resource.content = <<-HTML
#{resource.content}
<div data-controller="reading"
     data-reading-id-value="#{id}"
     data-reading-book-value="#{book.slug}">
</div>
HTML
  end
end