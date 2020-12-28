module Saber
  class CLI
    desc "seen", "NOT WORKGIN"
    def seen(*files)
      site_name = options["tracker"] || ENV["SABER_TRACKER"]

      files.each {|file|
        begin
          show = Tv::Naming.new(file)
        rescue EParse 
          Saber.ui.say "SKIP: #{file}"
          next
        end
        imdb_id = nil

        # local database 
        if Pa.exists?("#{Rc.p.home}/tv.yml")
          database = {}
          YAML.load_file("#{Rc.p.home}/tv.yml").each {|k,v| database[k.downcase] = v }
          imdb_id = database[show.name.downcase]
        end

        if not imdb_id
          Saber.ui.error "SKIP: no imdb id for #{show} -- #{file}"
          next
        end

        agent = Tv[site_name].new
        agent.seen(imdb_id: imdb_id, episodes: [{season: show.season, episode: show.episode}])
        Saber.ui.say "seen #{show} -- #{file}"
      }
    end
  end
end
