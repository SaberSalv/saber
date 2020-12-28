module Saber
  module Tracker2
    class What < Base
      BASE_URL = "https://what.cd"

      TYPES = {
        "music" => "Musics",
        "application" => "Applications",
        "ebook" => "E-Books",
        "audiobook" => "Audiobooks",
        "elearning-video" => "E-Learning Videos",
        "comedy" => "Comedy",
        "comic" => "Comics"
      }

      FIELDS = { 
        "ebook" => { 
          torrent_file: "//input[@name='file_input']",
          title: "//input[@name='title']",
          tags: "//input[@name='tags']",
          image: "//input[@name='image']",
          description: "//textarea[@name='desc']"
        }
      }
      
      def do_upload(file, info)
        #path = info["group_id"] ? "/upload.php?group_id=#{info['group_id']}" : "/upload.php"

        agent.goto "#{BASE_URL}/upload.php"
        check_login %r~/upload\.php~

        form = agent.form(action: "")
        form.select(name: "type").select info[:type2]
        form.input(value: "Find Info").wait_while_present unless info[:type] == "music"
        sleep 0.1

        FIELDS[info[:type]].each {|key, selector|
          form.set2(selector, info[key])
        }

        form.submit()

        if agent.url =~ %r~/upload\.php~
          return false
        else
          return true
        end
      end
    end
  end
end
