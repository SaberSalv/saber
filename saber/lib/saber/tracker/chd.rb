require "tagen/core/io"

module Saber
  module Tracker
    class CHD < Base
      BASE_URL = "https://chdbits.org"
      LOGIN_CHECK_PATH = "/messages.php"
      CACHE_FILE = "#{ENV['HOME']}/.saber/chd.cache"

      # cache {id: is_download}
      attr_accessor :cache

      def initialize
        super

        if Pa.exists?(CACHE_FILE)
          @cache = Marshal.load(File.read(CACHE_FILE))
        else
          @cache = {}
        end

        at_exit { 
          Saber.ui.debug "Exit."
          File.write(CACHE_FILE, Marshal.dump(cache))
        }
      end

      def add_torrents
        update_cache

        cache.each {|k,v|
          next if v 

          Retort::Service.call("load_start", build_download_link(k), "d.set_custom1=chd")
          Saber.ui.debug "Add #{Time.now.strftime("%H:%M:%S")} #{k}"
          cache[k] = true
        }

        # limit to 999 counts
        # 60 is too small, pin torrent may re-download
        self.cache = Hash[cache.to_a[-999..-1]] if cache.length > 999 
      end

      def update_cache(loaded=false)
        agent.get("/torrents.php") {|p|
          links = p.search("//*[@id='torrenttbale']//img[@class='pro_free']/preceding-sibling::a")
          #links = p.search("//*[@id='torrenttbale']//img[@class='pro_free' or @class='pro_50pctdown']/preceding-sibling::a")
          links.each {|link|
            id = link["href"].match(/id=(\d+)/)[1].to_i

            cache[id] = loaded unless cache.has_key?(id)
          }
        }
      end

    protected

      def build_download_link(id, passkey=nil)
        "http://chdbits.org/download.php?id=#{id}&passkey=#{passkey || Rc.chd.passkey}" 
      end

      def do_login_with_username(username)
        agent.get("/login.php") {|p|
          ret = p.form_with(action: "takelogin.php" ) {|f|
            # error. e.g. temporary disabled for failed logining exceed maxmium count.
            unless f 
              # print error in red color and exit the program.
              Saber.ui.error! p.at("//body").inner_text
            end

            f.username = username || ask("Username: ")
            f.password = ask("Password: "){|q| q.echo = false}
          }.submit

          # error
          if ret.uri.path == "/login"
            msg = ret.at("//*[@id='nav_block']/form[2]/p[2]/b/font").inner_text
            Saber.ui.error "Failed. You have #{msg} attempts remaining."
            return false
          else
            return true
          end
        }
      end
    end
  end
end

# vim: fdn=4
