require 'active_support/core_ext/numeric/conversions'

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
      generate_index_page_for_books
    end
  end

  def generate_index_page_for_books
    books = @books
    book_covers = books.map { |book| cover_for(book) }.join
    add_resource nil, "books.md" do
      layout "default"
      permalink "/books/"
      content <<-HTML
<ul class="list-none flex gap-6 py-10">
    #{book_covers}
</ul>
HTML
    end
  end

  def cover_for(book)
    chapters_json = book.chapter_ids.to_json.gsub('"', '&quot;')

    <<-HTML
<li data-controller="book" data-book-id-value="#{book.id}" data-book-chapters-value="#{chapters_json}" >
  <a class="flex flex-col gap-2 w-[236px] max-w-[236px]" href="#{book.link}">
    <div class="h-[378px] border rounded relative box-border" data-book-target="cover">
      <img src="#{book.cover}" class="h-[378px] w-[236px] rounded">
    </div>
    <div class="text-center">#{book.name}</div>
    <div class="text-sm text-center">#{authors book}</div>
  </a>
</li>
HTML
  end

  def authors(book)
    "by #{book.authors.join(", ")}" if book.authors?
  end

  def create_book_objects
    site.collections.books.resources
        .group_by { |b| b.id.split("_books/").last.split("/").first }
        .each do |book_id, chapters|
          meta_file = chapters.find { |c| c.relative_path.to_s.end_with?('00-meta.md') }
          regular_chapters = chapters.reject { |c| c.relative_path.to_s.end_with?('00-meta.md') }

          resource = add_resource(:book, "books/#{book_id}.md") { permalink "/books/:slug/" }
          @books << Book.new(resource, chapters: regular_chapters, meta: meta_file)
        end
  end

  def generate_books
    @books.each(&:generate)
  end
end

# noinspection ALL
class Book
  attr_accessor :name, :subtitle, :authors, :cover, :resource, :meta, :chapters
  delegate :id, to: :resource
  alias_method :title, :name

  def initialize(book, chapters:, meta:)
    @resource = book
    @meta = meta
    @chapters = []

    chapters.each do |chapter|
      @chapters << Chapter.new(chapter, book: self)
    end

    extract_metadata
  end

  #TODO: support other formats as well.
  def cover
    "#{resource.path.split(".").first}/cover.png"
  end

  def authors?
    @authors.present?
  end

  def extract_metadata
    @name = @meta&.data&.title || slug.titleize
    @subtitle = @meta&.data&.subtitle
    @authors = @meta&.data&.authors
  end

  def slug
    id.split("/").last.split(".md").first
  end

  def link
    resource.relative_url
  end

  def chapter_ids
    chapters.map(&:id)
  end

  def generate
    resource.data.layout = :book
    resource.data.title = title
    resource.content = content

    chapters.each(&:generate)
  end

  def content
    <<-HTML
<ul data-controller="bookmark" data-bookmark-chapter-outlet='.chapter' data-bookmark-book-value="#{id}">
 #{chapters.map { |chapter|
      li chapter
    }.join }
</ul>
    HTML
  end

  # TODO: may be convert these into compenents or partials.
  def li(chapter)
    <<-HTML
<li class='chapter flex justify-between items-end gap-4'
    data-controller='chapter'
    data-chapter-id-value='#{chapter.id}'
    data-chapter-ellipsis-class="text-orange-500"
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
     data-reading-book-value="#{book.id}">
</div>
    HTML
  end
end