require "pd"
require "pa"
require "yaml"
require "optimism"
require "saber/core_ext"
require "active_support/core_ext/numeric/bytes"
require "active_support/dependencies/autoload"
require "retort"

module Saber
  extend ActiveSupport::Autoload

  autoload :VERSION
  autoload :CLI
  autoload :UI
  autoload :Fetcher
  autoload :AutoFetcher
  autoload :Tracker
  autoload :Tracker2
  autoload :Book
  autoload :Tv

  Error = Class.new Exception
  FatalError = Class.new Exception
  EParse = Class.new Error

  Rc = Optimism.require "saber/rc", "~/.saberrc"

  class << self
    attr_accessor :ui

    def ui
      @ui ||= UI.new
    end
  end
end

Retort::Service.configure { |c| c.url = Saber::Rc.scgi_server }
