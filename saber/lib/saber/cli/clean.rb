module Saber
  class CLI
    desc "clean", "clean up files doesn't in rtorrent client"
    def clean
      disk_files = Pa.ls2(Rc.clean.dir, absolute: true)
      bt_files = Retort::Torrent.all.map{|t| Retort::Torrent.action("name", t.info_hash) }.map{|n| Pa.join2(Rc.clean.dir, n)}

      (disk_files - bt_files).each { |file|
        Pa.rm_r file, :verbose => true
      }
    end
  end
end
