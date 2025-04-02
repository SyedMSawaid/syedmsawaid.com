# frozen_string_literal: true
class Builders::Books < SiteBuilder
  def build
    generator do
      generate_page_of_content
      add_layout_to_book_chapters
    end
  end

  def add_layout_to_book_chapters
    site.collections.books.resources.each do |chapter|
      chapter.data.layout = "default"
      chapter.content = "#{chapter.content}\n#{stimulus_controller(
        "reading",
        values: {id: chapter.id, book: chapter.id.split("_books/").last.split("/").first})}"
    end
  end

  def generate_page_of_content
    book_ids = site.collections.books.resources.map {
      |b| b.id.split("_books/").last.split("/").first
    }.uniq

    book_ids.each do |book|
      content = create_chapters_list_for(book)
      add_resource :book, "books/#{book}.md" do
        layout :default
        title book.titlecase
        permalink "/books/:slug/"
        content content
      end
    end
  end

  def create_chapters_list_for(book)
    chapters = site.collections.books.resources.select { |b| b.id.include? book }

    <<-HTML
<ul data-controller="bookmark" data-bookmark-chapter-outlet='.chapter' data-bookmark-book-value="#{book}">
 #{chapters.map { |chapter| 
      "<li class='chapter' data-controller='chapter' data-chapter-id-value='#{chapter.id}'>
        <a href='#{chapter.relative_url}'>#{chapter.data.title}</a>
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