require "active_support/core_ext/module/attribute_accessors"

class SaberAPI
  # Usage
  #
  #  google = Backend["good_books"]
  #  google.book(isbn)
  #
  module Backend
    autoload :Base, "saber_api/backend/base"
    autoload :GoogleBooks, "saber_api/backend/google_books"
    autoload :Goodreads, "saber_api/backend/goodreads"
    autoload :Amazon, "saber_api/backend/amazon"

    BACKENDS = %w[google_books goodreads amazon]

    @@backends = {}
    mattr_reader :backends

    class << self
      def [](name)
        require "saber_api/backend/#{name}"

        backends[name]
      end

      # fetch data in concurrency.
      def book(isbn, *backends)
        ret_backends = []
        ret = {}

        threads = []
        mutex = Mutex.new
        backends.each {|backend|
          threads << Thread.new {
            data = Backend[backend].book(isbn)
            
            if not data.empty?
              mutex.synchronize {
                ret[backend] = data
                ret_backends << backend
              }
            end
          }
        }
        threads.each{|t| t.join}
        ret_backends.sort_by!{|v| i=backends.index(v); i.nil? ? 9999 : i }

        [ret, ret_backends]
      end
    end
  end
end
