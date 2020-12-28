module Saber
  class CLI
    desc "find_uploads <page>", "NOT WORKING"
    def find_uploads(page)
      require "tagen/core/io"
      require "isbn"

      bib = Tracker["bib"].new(options)
      stp = Tracker["stp"].new(options)
      dir = Rc._fetch("find_uploads.dir", ".")
      bib.agent.pluggable_parser["application/x-bittorrent"] = Mechanize::DirectorySaver.save_to(dir.to_s)
      bib.login
      stp.login

      bib.browse(page) {|torrent|
        title, isbn, download_link, filenames, tags = torrent[:title], torrent[:isbn], 
          torrent[:download_link], torrent[:filenames], torrent[:tags]

        generic_tags = convert_bibtags(tags)

        begin
          isbn = ISBN.thirteen(torrent[:isbn])
        rescue ISBN::Invalid13DigitISBN # empty
          next
        end

        if not stp.exists?(isbn: isbn)
          bib.get(download_link)

          Saber.ui.say "#{isbn} #{title}\n    #{filenames.join("\n    ")}"
          File.append("list", "#{filenames[0]}:#{isbn}\n")

          # local data
          local_data = Pa.exists?("#{Rc.p.database}/#{isbn}.yml") ? YAML.load_file("#{Rc.p.database}/#{isbn}.yml") : {}
          local_data.merge!({"tags" => generic_tags.join(", "), "bib.tags" => tags.join(", ")})
          File.write "#{Rc.p.database}/#{isbn}.yml", YAML.dump(local_data)
        end
      }
    end

  private

    def convert_bibtags(tags)
      tags.map {|v| 
        v.gsub(/ \(programming\)/i, '')
      }.sort_by {|v| 
        %w[fiction nonfiction].include?(v) ? -1 : tags.index(v)
      }
    end
  end
end
