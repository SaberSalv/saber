module Saber
  module Tracker
    class Gazelle < Base
      TAG_MAP = {
        "nonfiction" => "non.fiction"
      }

      def convert_tags(*tags)
        tags.map {|tag|
          tag = tag.downcase.gsub(/&/, "and").gsub(/ +/, ".").gsub(/'/, "")
          self.class::TAG_MAP[tag] || tag
        }
      end
    end
  end
end
