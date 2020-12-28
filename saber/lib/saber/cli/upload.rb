module Saber
  class CLI
    desc "upload [options] <format> <torrent_file/file ...>", "[make a torrent file and] upoad a torrent file to the site"
    method_option "add", aliases: "-a", desc: "upload via add format.", type: :boolean
    def upload(format, *names)
      names = names.map{|v| v.dup}
      tracker_name = options["tracker"] || ENV["SABER_TRACKER"]
      tracker2 = Tracker2[tracker_name].new(options)

      names.each { |name|
        format = case format.downcase
          when "auto"
            Pa.fext2(Pa.delete_ext(name, ".torrent"))
          else
            format
          end.downcase
        
        unless Rc.book_exts.include?(".#{format}")
          Saber.ui.error "SKIP: Unkown format -- #{format}" 
          next
        end

        filename = strip_filenames(name)[0]

        file = [
          "#{filename}.#{format}",
          "#{filename}"
        ].find {|v| Pa.exists?(v)}

        torrent_file = [
          "#{filename}.#{format}.torrent", 
          "#{tracker_name}/#{filename}.#{format}.torrent", 
          "#{filename}.torrent", 
          "#{tracker_name}/#{filename}.torrent"
        ].find {|v| Pa.exists?(v)}
        pd "upload", file, torrent_file

        # make torrent if torrent_file not exists.
        unless torrent_file
          unless file
            Saber.ui.error "SKIP: Can't find torrent_file nor file -- #{file}" 
            next
          end

          Saber.ui.say "Can't find torrent_file, begin to make it -- #{torrent_file}"
          CLI.new.invoke "make", [file], tracker: tracker_name
          torrent_file = "#{file}.torrent"
        end

        tracker2.upload(format, name, "#{filename}.yml", torrent_file, {add: options["add"]})
      }

      tracker2.exit
    end
  end
end
