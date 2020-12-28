require "google/api_client"
require "oj"
require "active_support/core_ext/object/try"

class SaberAPI
  module Backend
    class GoogleBooks < Base
      attr_reader :books

      LANGUAGE_MAP = {
        "en" => "English",
        "de" => "German",
        "fr" => "French",
        "es" => "Spanish",
        "it" => "Italian",
        "la" => "Latin",
        "ja" => "Japanese",
        "da" => "Danish",
        "sv" => "Swedish",
        "nb" => "Norwegian",
        "nl" => "Dutch",
        "ru" => "Russian",
        "pl" => "Polish",
        "pt" => "portuguese",
        "el" => "greek",
        "ga" => "irish",
        "gd" => "Gaelic",
        "ko" => "Korean",
        "zh-CN" => "Chinese Simplified",
        "zh-TW" => "Chinese Traditional",
        "ar" => "Arabic"
      }

      FIELD_MAP = {
        "id" => "id",
        "title" => "volumeInfo.title",
        "authors" => "volumeInfo.authors",
        "isbn" => proc{|v| v["volumeInfo"]["industryIdentifiers"].find{|isbn| isbn["type"] == "ISBN_13"}.try(:[], "identifier")},
        "isbn10" => proc{|v| v["volumeInfo"]["industryIdentifiers"].find{|isbn| isbn["type"] == "ISBN_10"}.try(:[], "identifier")},
        "publisher" => "volumeInfo.publisher",
        "pages" => "volumeInfo.pageCount",
        "publication_date" => "volumeInfo.publishedDate",
        "language" => proc{|v| LANGUAGE_MAP[v["volumeInfo"]["language"]]},
        "image" => "volumeInfo.imageLinks.thumbnail",
        "description" => "volumeInfo.description"
      }

      def initialize
        @client = Google::APIClient.new(authorization: nil, key: ENV["GOOGLE_KEY"])
        @books = client.discovered_api("books")
      end

      def book(isbn)
        result = client.execute(books.volumes.list, {"q" => "isbn:#{isbn}"})

        if result.error?
          puts "ERROR: #{result.error_message}"
          {}
        else
          SaberAPI.convert_fields(self, FIELD_MAP, result.data["items"][0])
        end
      end
    end
  end
end

# vim: fdn=4
