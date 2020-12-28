require "active_support/core_ext/string/inflections"

module Saber
  module Tv
    class Base
      def self.inherited(child)
        Tv.sites[child.name.demodulize.underscore] = child
      end
    end
  end
end

# vim: fdn=4
