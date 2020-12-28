require "thor"

module Saber
  class CLI < Thor
    include Thor::Actions

    class_option "no-color",               banner: "Disable colorization in output", type: :boolean
    class_option "verbose", aliases: "-V", banner: "Enable verbose output mode", type: :boolean
    class_option "log",                    banner: "Log file", type: :string
    class_option "force",                  banner: "Fore writing even if file exists", type: :boolean
    class_option "tracker", aliases: "-t", banner: "tracker name", type: :string
    class_option "dry-run", aliases: "-n", banner: "dry run", type: :boolean

    def initialize(*)
      super
      self.options = self.options.dup

      Saber.ui = if options["log"] then
        require "logger"
        UI::Logger.new(::Logger.new(options["log"]))
      else
        the_shell = (options["no-color"] ? Thor::Shell::Basic.new : shell)
        UI::Shell.new(the_shell)
      end

      Saber.ui.debug! if options["verbose"]

      # Initialize environment in first time
      unless Rc.p.home.exists?
        Pa.mkdir Rc.p.home 
        Pa.mkdir "#{Rc.p.home}/templates"
        Pa.mkdir "#{Rc.p.home}/database"
      end
    end

    desc "server", "start saber-server daemon"
    def server
      AutoFetcher::Server.start
    end

    desc "client", "start saber-client daemon"
    def client
      AutoFetcher::Client.start
    end

    desc "drb_add [options] <id,...> <label>", "add a file to saber-server daemon via drb."
    def drb_add(ids_str, label="")
      return if label != "saber"

      require "drb"

      names = ids_str.split(",").map{|v| Retort::Torrent.action("name", v)}

      AutoFetcher::DRbClient.new.add(*names)
    end

    desc "fetch [options] <file ..>", "fetch files from seedbox."
    def fetch(*names)
      Fetcher.new.add_names(*names)
    end

  private

    # a.yml -> a
    # a.epub.torrent -> a
    def strip_filenames(*names)
      names.map{|v| Pa.delete_ext(v, *%w[.torrent .yml]).delete_ext2(*Rc.book_exts)}
    end
  end
end

require "saber/cli/clean"
require "saber/cli/make"
require "saber/cli/upload"
require "saber/cli/find_uploads"
require "saber/cli/seen"
require "saber/cli/chd"
require "saber/cli/send"
require "saber/cli/generate"
