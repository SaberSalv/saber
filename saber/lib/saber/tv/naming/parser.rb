require "active_support/core_ext/string/inflections" 

module Saber
  module Tv
    class Naming
      # Prison.Break.S02E05.480p.HDTV.x264-mSD.mkv
      # Prison.Break.S01E04.Hero.Complex.480p.WEB-DL.x264-mSD.mkv
      #
      # Prison.Break.S02.720p.BluRay.DD5.1.x264-NTb
      #
      # -- special
      #
      # Revolution.2012.S01E06.576p.HDTV.x264-DGN.mkv
      # merlin_2008.5x08.the_hollow_queen.hdtv_x264-fov.mp4
      #
      # Conan.2012.11.06.Mindy.Kaling.720p.HDTV.x264-BAJSKORV
      #
      # arrow.105.hdtv-lol.mp4
      #
      # [HorribleSubs] Hunter X Hunter - 53 [720p].mkv
      class Parser
        def parse(filename)
          case filename
          # S01E02 
          when /^(.*)S(\d{2})E(\d{2})/i
            name, season, episode = $1, $2, $3
          # S01
          when /^(.*)S(\d{2})/i
            name, season = $1, $2
          # 2012.11.06
          when /^(.*)(\d{4})\.(\d{2})\.(\d{2})/i
            name, year, month, day = $1, $2
          # [HorribleSubs]
          when /\[HorribleSubs\] (.*) - (\d+)/i
            name, episode = $1, $2
          # 5x05
          when /^(.*)(\d)x(\d{2})/i
            name, season, episode = $1, $2, $3
            season = format("%02d",  season)
          # 105
          when /^(.*)(\d)(\d{2})/i
            name, season, episode = $1, $2, $3
            season = format("%02d",  season)
          else
            raise EParse, "unknown pattern -- #{filename}"
          end

          if name
            name = name.gsub(/[._]/, " ").strip

            # name remove 2011
            if name.match(/^(.*) \d{4}/)
              name = $1
            end

            # humanlize title
            #
            # person of interest -> Person of Interest
            name = name.titleize
            name.gsub!(/ Of /, " of ")
          end

          [name, season, episode]
        end
      end
    end
  end
end
