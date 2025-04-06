# frozen_string_literal: true
class Builders::Books < SiteBuilder
  def initialize(name = nil, current_site = nil)
    super
    @books = Hash.new
  end

  def build
    generator do
      generate_page_of_content
      add_layout_to_book_chapters
    end
  end

  def add_layout_to_book_chapters
    site.collections.books.resources.each do |chapter|
      chapter.data.layout = "chapter"
      chapter.data.book_title = get_book_title(chapter)
      chapter.data.book_link = get_book_link(chapter)
      chapter.content = "#{chapter.content}\n#{stimulus_controller(
        "reading",
        values: {id: chapter.id, book: chapter.id.split("_books/").last.split("/").first})}"
    end
  end

  def get_book_link(chapter)
    @books.each do |book_id, book_resource|
      return book_resource.relative_url if chapter.id.include? book_id
    end
  end

  def get_book_title(chapter)
    chapter.id.split("_books/").last.split("/").first.titlecase
  end

  def generate_page_of_content
    book_ids = site.collections.books.resources.map {
      |b| b.id.split("_books/").last.split("/").first
    }.uniq

    book_ids.each do |book|
      content = create_chapters_list_for(book)

      generated_book = add_resource :book, "books/#{book}.md" do
        layout :book
        title book.titlecase
        permalink "/books/:slug/"
        content content
      end

      @books[book] = generated_book
    end
  end

  def create_chapters_list_for(book)
    chapters = site.collections.books.resources.select { |b| b.id.include? book }

    <<-HTML
<ul data-controller="bookmark" data-bookmark-chapter-outlet='.chapter' data-bookmark-book-value="#{book}">
 #{chapters.map { |chapter| 
      "<li class='chapter' data-controller='chapter' data-chapter-id-value='#{chapter.id}'>
        <a href='#{chapter.relative_url}'>#{chapter.data.title}</a>
        <div>your mom</div>
        <div data-chapter-target='bookmark'></div>
       </li>" 
    }.join }
</ul>
    HTML
  end

  def stimulus_controller(name, values: {})
    values = values.map { |k, v| "data-#{name}-#{k}-value='#{v}'" }.join(" ")
    <<-HTML
<div data-controller='#{name}' #{values}></div>
    HTML
  end
end