module Saber
  module Tracker2
    class BB < Gazelle
      BASE_URL = "https://baconbits.org"

      TYPES = {
        "music" => "Musics",
        "application" => "Applications",
        "ebook" => "E-Books",
        "audiobook" => "Audiobooks",
        "elearning-video" => "E-Learning Videos",
        "magazine" => "Magazines",
        "comic" => "Comics",
        "anime" => "Anime",
        "movie" => "Movies",
        "tv" => "TV",
        "game-pc" => "Game - PC",
        "game-console" => "Game - Console",
        "documentary" => "Documentaries",
        "misc" => "Misc"
      }

      FIELDS = { 
        "music" => {
          torrent_file: "//input[@name='file_input']",
          artist: "//input[@name='artist']",
          title: "//input[@name='title']",
          remaster: "//input[@name='remaster']",
          year: "//input[@name='year']",
          scene: "//input[@name='scene']",
          format: "//select[@name='format']",
          bitrate: "//select[@name='bitrate']",
          media: "//select[@name='media']",
          tags: "//input[@name='tags']",
          image: "//input[@name='image']",
          description: "//input[@name='album_desc']",
          release_description: "//input[@name='release_desc']"
        },

        "application" => {
          torrent_file: "//input[@name='file_input']",
          title: "//input[@name='title']",
          tags: "//input[@name='tags']",
          description: "//textarea[@name='desc']",
          image: "//input[@name='image']",
          scene: "//input[@name='scene']"
        },

        "ebook" => { 
          torrent_file: "//input[@name='file_input']",
          title: "//input[@name='title']",
          tags: "//input[@name='tags']",
          format: "//select[@name='book_format']",
          isbn: "//input[@name='book_isbn']",
          authors: "//input[@name='book_author']",
          publisher: "//input[@name='book_publisher']",
          language: "//input[@name='book_language']",
          year: "//input[@name='book_year']",
          retail: "//input[@name='book_retail']",
          description: "//textarea[@name='desc']",
          image: "//input[@name='image']",
          scene: "//input[@name='scene']"
        },

        "audiobook" => {
          torrent_file: "//input[@name='file_input']",
          title: "//input[@name='title']",
          year: "//input[@name='year']",
          format: "//select[@name='format']",
          bitrate: "//select[@name='bitrate']",
          tags: "//input[@name='tags']",
          image: "//input[@name='image']",
          description: "//input[@name='album_desc']",
          release_description: "//input[@name='release_desc']"
        },

        "elearning-video" => {
          torrent_file: "//input[@name='file_input']",
          title: "//input[@name='title']",
          tags: "//input[@name='tags']",
          isbn: "//input[@name='book_isbn']",
          description: "//textarea[@name='desc']",
          image: "//input[@name='image']",
          scene: "//input[@name='scene']"
        },

        "magazine" => {
          torrent_file: "//input[@name='file_input']",
          title: "//input[@name='title']",
          tags: "//input[@name='tags']",
          description: "//textarea[@name='desc']",
          image: "//input[@name='image']",
          scene: "//input[@name='scene']"
        },

        "comic" => {
          torrent_file: "//input[@name='file_input']",
          title: "//input[@name='title']",
          tags: "//input[@name='tags']",
          isbn: "//input[@name='book_isbn']",
          description: "//textarea[@name='desc']",
          image: "//input[@name='image']",
          scene: "//input[@name='scene']"
        },

        "anime" => {
          torrent_file: "//input[@name='file_input']",
          title: "//input[@name='title']",
          tags: "//input[@name='tags']",
          description: "//textarea[@name='desc']",
          image: "//input[@name='image']",
          scene: "//input[@name='scene']"
        },

        "movie" => {
          torrent_file: "//input[@name='file_input']",
          title: "//input[@name='title']",
          source: "//select[@name='source']",
          videoformat: "//select[@name='videoformat']",
          audioformat: "//select[@name='audioformat']",
          container: "//select[@name='container']",
          resolution: "//select[@name='resolution']",
          remaster_title: "//input[@name='remaster_title']",
          year: "//input[@name='year']",
          tags: "//input[@name='tags']",
          description: "//textarea[@name='desc']",
          release_info: "//textarea[@name='release_info']",
          screenshot1: "//input[@name='screenshot1']",
          screenshot2: "//input[@name='screenshot2']",
          image: "//input[@name='image']",
          scene: "//input[@name='scene']"
        },

        "tv" => {
          torrent_file: "//input[@name='file_input']",
          title: "//input[@name='title']",
          tags: "//input[@name='tags']",
          description: "//textarea[@name='desc']",
          image: "//input[@name='image']",
          scene: "//input[@name='scene']"
        },

        "game-pc" => {
          torrent_file: "//input[@name='file_input']",
          title: "//input[@name='title']",
          tags: "//input[@name='tags']",
          description: "//textarea[@name='desc']",
          image: "//input[@name='image']",
          scene: "//input[@name='scene']"
        },

        "game-console" => {
          torrent_file: "//input[@name='file_input']",
          title: "//input[@name='title']",
          tags: "//input[@name='tags']",
          description: "//textarea[@name='desc']",
          image: "//input[@name='image']",
          scene: "//input[@name='scene']"
        },

        "documentary" => {
          torrent_file: "//input[@name='file_input']",
          title: "//input[@name='title']",
          source: "//select[@name='source']",
          videoformat: "//select[@name='videoformat']",
          audioformat: "//select[@name='audioformat']",
          container: "//select[@name='container']",
          resolution: "//select[@name='resolution']",
          remaster_title: "//input[@name='remaster_title']",
          year: "//input[@name='year']",
          tags: "//input[@name='tags']",
          description: "//textarea[@name='desc']",
          release_info: "//textarea[@name='release_info']",
          screenshot1: "//input[@name='screenshot1']",
          screenshot2: "//input[@name='screenshot2']",
          image: "//input[@name='image']",
          scene: "//input[@name='scene']"
        },

        "misc" => {
          torrent_file: "//input[@name='file_input']",
          title: "//input[@name='title']",
          tags: "//input[@name='tags']",
          description: "//textarea[@name='desc']",
          image: "//input[@name='image']",
          scene: "//input[@name='scene']"
        },
      }

      def fill_form(form, info)
        form.select(name: "type").select info[:upload_type2]
        sleep 0.1
        form.h2(text: "Getting Form...").wait_while_present unless info[:upload_type] == "music"
        sleep 0.1

        FIELDS[info[:upload_type]].each {|key, selector|
          form.set2(selector, info[key])
        }

        # comic
        if info[:upload_type] == "comic"
          info[:format].split(",").each { |format|
            form.input(value: format).set true
          }
        end
      end

      def process_info!(info)
        info[:description] = <<-EOF

[size=3][b][color=#FF3300]Book Details:[/color][/b][/size]
[size=2][quote]
#{info[:release_description].strip}
[/quote][/size]
[size=3][b][color=#FF3300]Book Description:[/color][/b][/size]
[quote][size=2]#{info[:description].strip}
[/size][/quote]
        EOF
      end
    end
  end
end

# vim: fdn=4
