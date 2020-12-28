require "active_support/core_ext/module/attribute_accessors"

module Saber
  module Tv
    @@sites = {}
    mattr_reader :sites

    class << self
      def [](name)
        sites[name]
      end
    end
  end
end

require "saber/tv/base"
require "saber/tv/naming"
require "saber/tv/trakt"
