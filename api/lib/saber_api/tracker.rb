require "active_support/core_ext/module/attribute_accessors"
require "active_support/core_ext/object/try"
require "imgur"

class SaberAPI
  class Tracker
    autoload :Base, "saber_api/tracker/base"
    autoload :General, "saber_api/tracker/general"
    autoload :STP, "saber_api/tracker/stp"
    autoload :BB, "saber_api/tracker/bb"
    autoload :What, "saber_api/tracker/what"
    autoload :BIB, "saber_api/tracker/bib"

    @@trackers = {}
    mattr_reader :trackers

    FIELD_MAP = {
      "title" => "title",
      "title2" => nil,
      "authors" => proc{|v| v["authors"].join(",")},
      "isbn" => nil,
      "publisher" => "publisher",
      "pages" => "pages",
      "year" => proc{|v| v["publication_date"].split("-")[0]},
      "language" => "language",
      "tags" => proc{|v| v["tags"].try(:join, ", ")},
      "image" => proc{|v| 
        begin
          if v["image"].empty?
            v["image"]
          else
            @imgur.upload_from_url(v["image"])["original_image"]
          end
        rescue Imgur::ImgurError
          v["image"]
        end
      },
      "description" => nil,
      "release_description" => nil,
    }

    class << self
      def [](name)
        require "saber_api/tracker/#{name}"
        trackers[name]
      end
    end

    attr_reader :imgur 

    def initialize
      @imgur = Imgur::API.new(ENV["IMGUR_KEY"])
    end

    def book(isbn, default, data, *trackers)
      ret = SaberAPI.convert_fields(self, self.class::FIELD_MAP, default)
      ret["isbn"] = isbn

      # filter
      trackers.each{|tracker|
        Tracker[tracker].filter(ret, default, data)
      }

      ret
    end
  end
end
