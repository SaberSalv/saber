require "active_support/core_ext/string/inflections"

class SaberAPI
  module Backend
    class Base
      def self.inherited(child)
        Backend.backends[child.name.demodulize.underscore] = child
      end

      # delegate to #book
      def self.book(*args)
        new.book(*args)
      end

      attr_reader :client

      # Implement
      # FIELD_MAP = {}

      # Implement
      #
      # error return empty hash.
      #
      # @return [Hash] data
      def book(isbn) 
        raise NotImplementedError
      end
    end
  end
end
