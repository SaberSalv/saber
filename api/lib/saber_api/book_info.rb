require "active_support/core_ext/object/blank"

class SaberAPI
  # find data info from various backends
  class BookInfo < Hash
    attr_reader :data, :backends

    def initialize(data, backends)
      @data = data
      @backends = backends
    end

    # "description"  -> description
    def [](key)
      b = backend(key)
      return "" unless b

      data[b][key]
    end
    
    # "description"   -> backend
    def backend(key)
      backends.find{|b| data[b][key].present? }
    end
  end
end
