module Saber
  module Tracker
    class BB < Gazelle
      BASE_URL = "https://baconbits.org"
      LOGIN_CHECK_PATH = "/inbox.php"

      FIELDS = { 
        "Musics" => {
          "file_input" => :file_upload,
          "type" => :select_list,
          "artist" => :text,
          "title" => :text,
          "remaster" => :check_box,
          "year" => :text,
          "scene" => :checkbox,
          "format" => :select_list,
          "bitrate" => :select_list,
          "media" => :select_list,
          "tags" => :text,
          "image" => :text,
          "album_desc" => :text,
          "release_desc" => :text,
        },

        "Applications" => {
          "file_input" => :file_upload,
          "type" => :select_list,
          "title" => :text,
          "tags" => :text,
          "desc" => :text,
          "image" => :text,
          "scene" => :checkbox,
        },

        "E-Books" => {
          "file_input" => :file_upload,
          "type" => :select_list,
          "title" => :text,
          "tags" => :text,
          "isbn" => :text,
          "desc" => :text,
          "image" => :text,
          "scene" => :checkbox,
        },

        "Audiobooks" => {
          "file_input" => :file_upload,
          "type" => :select_list,
          "title" => :text,
          "year" => :text,
          "format" => :select_list,
          "bitrate" => :select_list,
          "tags" => :text,
          "image" => :text,
          "album_desc" => :text,
          "release_desc" => :text,
        },

        "E-Learning Videos" => {
          "type" => :select_list,
          "title" => :text,
          "tags" => :text,
          "isbn" => :text,
          "desc" => :text,
          "image" => :text,
          "scene" => :checkbox,
        },

        "Magazines" => {
          "file_input" => :file_upload,
          "type" => :select_list,
          "title" => :text,
          "tags" => :text,
          "desc" => :text,
          "image" => :text,
          "scene" => :checkbox,
        },

        "Comics" => {
          "file_input" => :file_upload,
          "type" => :select_list,
          "title" => :text,
          "tags" => :text,
          "isbn" => :text,
          "desc" => :text,
          "image" => :text,
          "scene" => :checkbox,
        },

        "Anime" => {
          "file_input" => :file_upload,
          "type" => :select_list,
          "title" => :text,
          "tags" => :text,
          "desc" => :text,
          "image" => :text,
          "scene" => :checkbox,
        },

        "Movies" => {
          "file_input" => :file_upload,
          "type" => :select_list,
          "title" => :text,
          "source" => :select_list,
          "videoformat" => :select_list,
          "audioformat" => :select_list,
          "container" => :select_list,
          "resolution" => :select_list,
          "remaster_title" => :text,
          "year" => :text,
          "tags" => :text,
          "desc" => :text,
          "release_info" => :text,
          "screenshot1" => :text,
          "screenshot2" => :text,
          "image" => :text,
          "scene" => :checkbox,
        },

        "TV" => {
          "file_input" => :file_upload,
          "type" => :select_list,
          "title" => :text,
          "tags" => :text,
          "desc" => :text,
          "image" => :text,
          "scene" => :checkbox,
        },

        "Games - PC" => {
          "file_input" => :file_upload,
          "type" => :select_list,
          "title" => :text,
          "tags" => :text,
          "desc" => :text,
          "image" => :text,
          "scene" => :checkbox,
        },

        "Games - Console" => {
          "file_input" => :file_upload,
          "type" => :select_list,
          "title" => :text,
          "tags" => :text,
          "desc" => :text,
          "image" => :text,
          "scene" => :checkbox,
        },

        "Documentaries" => {
          "file_input" => :file_upload,
          "type" => :select_list,
          "title" => :text,
          "source" => :select_list,
          "videoformat" => :select_list,
          "audioformat" => :select_list,
          "container" => :select_list,
          "resolution" => :select_list,
          "remaster_title" => :text,
          "year" => :text,
          "tags" => :text,
          "desc" => :text,
          "release_info" => :text,
          "screenshot1" => :text,
          "screenshot2" => :text,
          "image" => :text,
          "scene" => :checkbox,
        },

        "Misc" => {
          "file_input" => :file_upload,
          "type" => :select_list,
          "title" => :text,
          "tags" => :text,
          "desc" => :text,
          "image" => :text,
          "scene" => :checkbox,
        },
      }
      
    protected

      # Attpened to login the site with username and password. this happens 
      # after login failed with cookie. 
      def do_login_with_username(username)
        agent.get("/login.php") {|p|
          ret = p.form_with(action: "login.php" ) {|f|
            unless f 
              Saber.ui.error! p.at("//body").inner_text
            end

            f.username = username || ask("Username: ")
            f.password = ask("Password: "){|q| q.echo = false}
            f.checkbox(name: "keeplogged").check
          }.submit

          # error
          if ret.uri.path == "/login.php"
            msg = ret.at("//*[@id='loginform']/font[2]").inner_text
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
