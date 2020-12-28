require "faraday"
require "faraday_middleware"

module Saber
  class Book
    # delegate to #populate
    def self.populate(*args)
      new.populate(*args)
    end

    attr_reader :client
    
    def initialize
      @client = Faraday.new(url: Rc.api_url) {|c|
        c.response :follow_redirects
        c.response :json, :content_type => /\bjson$/

        c.adapter Faraday.default_adapter
      }
    end

    # @return [Hash] data
    def populate(isbn, filename)
      params = {}
      rep = client.get("/books/#{isbn}", params)
      data = rep.body

      if data["status"] == 0
        data["tracker"]
      else
        Saber.ui.error "Can't populate book -- #{isbn} #{filename}."
        {}
      end
    end
  end
end
