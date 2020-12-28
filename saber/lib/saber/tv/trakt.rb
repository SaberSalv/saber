require "trakt"

module Saber
  module Tv
    class Trakt < Base
      attr_reader :agent

      def initialize
        @agent = ::Trakt.new
        @agent.apikey = Rc.trakt.apikey 
        @agent.username = Rc.trakt.username
        @agent.password = Rc.trakt.password
      end

      # {imdb_id: x} 
      # {imdb_id: x, episodes: [{season: 1, episode: 2}]}
      def seen(data={})
        if data.has_key?(:episodes)
          agent.show.episode_seen(data)
        else
          agent.show.seen(data)
        end
      end
    end
  end
end
