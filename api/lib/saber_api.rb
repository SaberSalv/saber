require "pd"
require "tagen/core"
require "date"
require "nokogiri"
require "active_support/core_ext/object/try"
require "isbn"

class SaberAPI
  autoload :Backend, "saber_api/backend"
  autoload :Tracker, "saber_api/tracker"
  autoload :BookInfo, "saber_api/book_info"

  ROOT = File.expand_path("../..", __FILE__) 
  @@bbcode_xsl = File.read("#{ROOT}/vendor/xslt/bbcode/bbcode.xsl")

  class << self
    def book(isbn, params)
      isbn = ISBN.thirteen(isbn)
      ret = {}

      trackers = (params["tracker"] || "general").split(",")
      backends = (params["tracker_backend"] || "").split(",")
      backends += trackers.map{|v| Tracker[v]::BACKENDS}.flatten
      backends = %w[amazon] if backends.empty? # default backend
      backends.uniq!

      data, ret_backends = Backend.book(isbn, *backends)

      if ret_backends.empty?
        ret["status"] = 2
      else
        ret["status"] = 0
        ret["backends"] = ret_backends
        default = BookInfo.new(data, ret_backends)
        ret["tracker"] = Tracker.new.book(isbn, default, data, *trackers)
      end

      ret
    end

    ## private

    # convert data based on field_map
    # @private
    #
    # @param [Hash,BookInfo] data
    #
    #   field_map = {
    #     "title" => "Title",
    #     "author" => "author.name",
    #     "date" => proc {|v| Date.new(v["date"]) }
    #   }
    def convert_fields(instance, field_map, data)
      ret = {}
      return ret if data.nil?

      field_map.each {|to, from|
        value = case from
        when String
          swap = data
          from.split(".").each{|field| swap = swap.try(:[], field) }
          swap
        when Proc
          instance.instance_exec(data, &from)
        end

        ret[to] = case value
          when NilClass
            value.to_s
          when String
            value.strip
          when Array
            value.map{|v| v.strip}
          end
      }

      ret
    end

    # @private
    def html2bbcode(html, params={})
      return "" if html.empty?

      doc = Nokogiri::HTML(html)
      xslt = Nokogiri::XSLT(@@bbcode_xsl, Nokogiri::XSLT.quote_params(params))
      xslt.transform(doc).children[0].inner_text.strip
    end
  end
end
