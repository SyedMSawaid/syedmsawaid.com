# frozen_string_literal: true
class Builders::Books < SiteBuilder
  def build
    generator do
      generate_page_for_books
      add_layout_to_book_chapters
    end
  end

  def add_layout_to_book_chapters
    site.collections.books.resources.each do |chapter|
      chapter.data.layout = "default"
    end
  end

  def generate_page_for_books
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
<ul>
 #{chapters.map { |chapter| "<li><a href='#{chapter.relative_url}'>#{chapter.data.title}</a></li>" }.join}
</ul>
    HTML
  end
end