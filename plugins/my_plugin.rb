require_all "bridgetown-core/commands/concerns"

module MyPlugin
  module Commands
    # -----------------------------
    # Chapters subcommand
    # -----------------------------
    class Chapters < Thor
    desc "add", "Add a new chapter to a book"
    option :book, type: :string, required: true, desc: "Title of the book"
    option :title, type: :string, required: true, desc: "Title of the chapter"
    def add
      book_title = options[:book]
      chapter_title = options[:title]
      folder_path = File.join("src", "_books", book_title.parameterize)

      unless Dir.exist?(folder_path)
        puts "Book not found: #{book_title}"
        return
      end

      # Find the last chapter number
      existing_chapters = Dir.children(folder_path)
                             .select { |f| f =~ /^\d{2}-.*\.md$/ }
                             .sort
      last_number = if existing_chapters.empty?
                      0
                    else
                      existing_chapters.last.split("-").first.to_i
                    end

      new_number = format("%02d", last_number + 1)
      chapter_file = File.join(folder_path, "#{new_number}-#{chapter_title.parameterize}.md")

      content = <<~MARKDOWN
    ---
    title: #{chapter_title}
    ---
    MARKDOWN

      File.write(chapter_file, content)
      puts "Chapter created: #{chapter_file}"
    end
  end


  # -----------------------------
    # Book command
    # -----------------------------
    class Book < Thor
      include Bridgetown::Commands::ConfigurationOverridable

      Bridgetown::Commands::Registrations.register do
        desc "book <command>", "Take me to the book"
        subcommand "book", Book
      end

      desc "setup", "Setup folders and files for books"
      def setup
        create_books_folder
        add_books_collection_to_config
      end

      desc "new", "Create a new book"
      option :title, type: :string, required: true, desc: "Title of the book"
      def new
        title = options[:title]
        folder_path = File.join("src", "_books", title.parameterize)

        if Dir.exist?(folder_path)
          puts "Folder already exists: #{folder_path}"
        else
          FileUtils.mkdir_p(folder_path)
          puts "Folder created: #{folder_path}"
        end

        file_path = File.join(folder_path, "00-meta.md")
        content = <<~MARKDOWN
        ---
        title: #{title}
        subtitle: 
        authors: [  ]
        ---
        MARKDOWN

        File.write(file_path, content)
        puts "Creating a new book with title: #{title}"
      end

      # Register Chapters as a nested subcommand
      desc "chapters <command>", "Manage chapters of a book"
      subcommand "chapters", Chapters

      private

      def create_books_folder
        folder_path = File.join("src", "_books")

        if Dir.exist?(folder_path)
          puts "Folder already exists: #{folder_path}"
        else
          FileUtils.mkdir_p(folder_path)
          puts "Folder created: #{folder_path}"
        end
      end

      def add_books_collection_to_config
        config_file = "bridgetown.config.yml"
        unless File.exist?(config_file)
          puts "Config file not found: #{config_file}"
          return
        end

        content = File.read(config_file)
        if content =~ /books:/
          puts "'books' collection already exists, skipping..."
          return
        end

        config = YAML.load_file(config_file) || {}
        config["collections"] ||= {}
        config["collections"]["books"] = {
          "output" => true,
          "permalink" => "/books/:path/"
        }

        File.write(config_file, config.to_yaml)
        puts "'books' collection added/updated in #{config_file}"
      end
    end
  end
end
