require "watir"
require "tagen/watir"
require "reverse_markdown"
require "active_support/core_ext/module/attribute_accessors"

module Saber
  # Usage
  #
  #  bib = Tracker2["bib"].new
  #  bib.upload("Hello.epub")
  #
  module Tracker2
    @@trackers = {}
    mattr_reader :trackers

    class << self
      def [](name)
        trackers[name]
      end
    end
  end
end

require "saber/tracker2/base"
require "saber/tracker2/gazelle"
require "saber/tracker2/what"
require "saber/tracker2/bib"
require "saber/tracker2/bb"
require "saber/tracker2/stp"
