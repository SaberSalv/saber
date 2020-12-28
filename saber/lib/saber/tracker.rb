require "mechanize"
require "saber/mechanize_ext"
require "highline/import"
require "reverse_markdown"
require "json"
require "active_support/core_ext/module/attribute_accessors"

module Saber
  # Usage
  #
  #  bib = Tracker["bib"].new
  #  bib.login
  #  bib.upload("Hello.epub.torrent")
  #
  module Tracker
    @@trackers = {}
    mattr_reader :trackers

    class << self
      def [](name)
        trackers[name]
      end
    end
  end
end

require "saber/tracker/base"
require "saber/tracker/gazelle"
require "saber/tracker/what"
require "saber/tracker/bb"
require "saber/tracker/bib"
require "saber/tracker/stp"
require "saber/tracker/chd"
require "saber/tracker/ptp"
