module Saber
  class CLI 
    desc "make [options] <file ..>", "make a torent file and send it to local and/or remote watch directory"
    method_option "option", aliases: "-o", desc: "extra options passed to mktorrent", type: :string
    method_option "file", aliases: "-f", desc: "read files from file list", type: :string
    def make(*files)
      require "shellwords"
      require "tagen/core/kernel/shell"

      tracker_name = options["tracker"] || ENV["SABER_TRACKER"]
      files = File.read(options["file"]).split(/\n+/).map{|v| v.strip.split(":")[0] } if options["file"]

      Saber.ui.error! "You need set #{tracker_name}.announce_url in ~/.saberrc first" unless 
        Rc._has_key?("#{tracker_name}.announce_url")

      files.each { |file|
        torrent_file = "#{file}.torrent"

        if Pa.exists?(torrent_file) 
          if options["force"]
            Pa.rm torrent_file
          else
            Saber.ui.say "SKIP make: #{torrent_file} (torrent alreay exists. use --force to overwrite it.)"
            next
          end
        end

        if not Pa.exists?(file)
          Saber.ui.error "SKIP: can't find file to make -- #{file}"
          next
        end

        extra_options = Rc._fetch(["#{tracker_name}.mktorrent_options", "mktorrent_options"], "")
        cmd = "mktorrent -p #{extra_options} -a #{Rc[tracker_name].announce_url} #{file.shellescape} #{options['option']}"
        system cmd, show_cmd: "$"

        # cp tororent file
        if Rc._has_key?("make.watch")
          Pa.cp_f torrent_file, Rc.make.watch, show_cmd: "$"
        end

        if Rc._has_key?("make.remote_watch")
          CLI.new.invoke "send1", [torrent_file, Rc.make.remote_watch]
        end

        # move torrent file
        if Rc._has_key?("make.dir")
          Pa.mv_f torrent_file, Rc.make.dir, show_cmd: "$"
        end

        Saber.ui.say ""
      }
    end
  end
end
