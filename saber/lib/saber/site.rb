require "active_support/core_ext/module/attribute_accessors"

module Saber
  module Site
    @@sites = {}
    mattr_reader :sites

    class << self
      def [](name)
        sites[name]
      end
    end
  end
end

require "saber/site/tvdb"
