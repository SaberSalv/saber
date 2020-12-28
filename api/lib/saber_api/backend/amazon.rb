require "amazon/ecs"
require "active_support/core_ext/object/try"
require "active_support/core_ext/hash/conversions"

class SaberAPI
  module Backend
    class Amazon < Base
      ::Amazon::Ecs.configure do |options|
        options[:associate_tag] = ENV["AMAZON_TAG"]
        options[:AWS_access_key_id] = ENV["AMAZON_KEY"]
        options[:AWS_secret_key] = ENV["AMAZON_SECRET"]
      end

      FIELD_MAP = {
        "id" => "ASIN",
        "title" => "ItemAttributes.Title",
        "isbn" => "ItemAttributes.EAN",
        "isbn10" => "ItemAttributes.ISBN",
        "authors" => proc{|v| Array.wrap(v["ItemAttributes"]["Author"]) },
        "publisher" => "ItemAttributes.Publisher",
        "pages" => "ItemAttributes.NumberOfPages",
        "publication_date" => "ItemAttributes.PublicationDate",
        "language" => proc {|v| v["ItemAttributes"]["Languages"]["Language"][0].try(:[], "Name") },
        "image" => "LargeImage.URL",
        "description" => proc {|v| v["EditorialReviews"]["EditorialReview"].find{|v| v["Source"] == "Product Description"}.try(:[], "Content") }
      }

      def initialize
        @client = ::Amazon::Ecs
      end

      def book(isbn)
        result = client.item_lookup(isbn, "IdType" => "ISBN", "SearchIndex" => "Books", "ResponseGroup" => "ItemAttributes,EditorialReview,Images")

        if result.has_error? or result.items.length == 0
          {}
        else
          data = Hash.from_xml(result.items[0].to_s)["Item"]

          # fix
          data["EditorialReviews"] ||= {"EditorialReview" => []}
          data["ItemAttributes"]["Languages"] ||= {"Language" => []}
          if Hash === data["EditorialReviews"]["EditorialReview"]
            data["EditorialReviews"]["EditorialReview"] = [data["EditorialReviews"]["EditorialReview"]]
          end

          SaberAPI.convert_fields(self, FIELD_MAP, data)
        end
      end
    end
  end
end

# vim: fdn=4
