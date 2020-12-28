module Saber
  class CLI
    desc "chd", "NOT WORKING"
    def chd
      require "sys/filesystem"

      t = Tracker["chd"].new

      begin
        t.login
        Saber.ui.say "Begin to watch."
        # mark all loaded.
        t.update_cache(true)

        while true
          # check free diskspace
          s = Sys::Filesystem.stat(Rc.p.dir.p)
          if s.block_size * s.blocks_available < Rc.chd.diskspace_limit
            Saber.ui.say "Reach low diskspace, begin Clean up."
            Retort::Service.call("d.multicall", "complete", "d.hash=", "d.base_path=", "d.custom1=", "d.up.rate=").each {|id, file, tag, up_rate|
              next if tag != "chd"

              if up_rate < Rc.chd.up_rate_limit
                Retort::Service.call("d.erase", id)

                Pa.rm_rf file, show_cmd: "$"
              end
            }
          end

          Saber.ui.say "Begin to add torrents."
          t.add_torrents

          sleep Rc.chd.update_interval
        end
      rescue Errno::ETIMEDOUT, Mechanize::ResponseCodeError, SocketError => e
        Saber.ui.error "Retry: #{e.message}"
        sleep 60
        retry
      end
    end
  end
end
