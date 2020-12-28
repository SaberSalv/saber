require "active_support/core_ext/string/inflections"

class SaberAPI
  class Tracker
    class General < Base
      BACKENDS = %w[amazon google_books goodreads]

      def filter(ret, default, data)
        amazon, google, goodreads = data["amazon"], data["google_books"], data["goodreads"]

        # title2
        ret["title2"] = goodreads["title"] if goodreads

        # description
        websites = []
        websites << "[url=http://amzn.com/#{amazon["id"]}]Amazon[/url]" if amazon
        websites << "[url=http://books.google.com/books?id=#{google["id"]}]Google Books[/url]" if google
        websites << "[url=http://www.goodreads.com/book/show/#{goodreads["id"]}]Goodreads[/url]" if goodreads

        ret["release_description"] = <<-EOF
[b]Title:[/b] #{default["title"]}
[b]Authors:[/b] #{default["authors"].join(",")}
[b]Publisher:[/b] #{default["publisher"]}
[b]ISBN:[/b] #{default["isbn"]}
[b]ISBN-10:[/b] #{default["isbn10"]}
[b]Publication Date:[/b] #{default["publication_date"]}
[b]Number of Pages:[/b] #{default["pages"]}
[b]Language:[/b] #{default["language"]}
[b]Website:[/b] #{websites.join(", ")}
        EOF

        ret["description"] = SaberAPI.html2bbcode(default["description"])
      end
    end
  end
end
