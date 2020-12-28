require "active_support/core_ext/object/try"

module Saber
  module Tracker
    class PTP < Base
      BASE_URL = "https://tls.passthepopcorn.me"
      LOGIN_CHECK_PATH = "/inbox.php"

      FIELDS = { 
        "new" => {
          "file_input" => :file_upload,
          "type" => :select_list,
          "title" => :text,
          "year" => :text,
          "image" => :text,
          "trailer" => :text,
          "special" => :checkbox,
          "remaster" => :checkbox,
          "scene" => :checkbox,
          "source" => :select_list,
          "codec" =>  :select_list,
          "container" => :select_list,
          "resolution" => :select_list,
          "tags" => :text,
          "album_desc" => :text,
          "release_desc" => :text,
        },

        "add" => {
          "file_input" => :file_upload,
          "special" => :checkbox,
          "remaster" => :checkbox,
          "scene" => :checkbox,
          "source" => :select_list,
          "codec" =>  :select_list,
          "container" => :select_list,
          "resolution" => :select_list,
          "release_desc" => :text,
        },
      }
      
      def do_upload(file, info)
        info["file_input"] = "#{file}.torrent"
        path = info["group_id"] ? "/upload.php?group_id=#{info['group_id']}" : "/upload.php"
        agent.get(path) {|p|
          ret = p.form_with(action: "") {|f|
            FIELDS[info.type].each {|k,t|
              f.set(t, k, info[k])
            }

            # subtitles[]
            info["subtitles"].each {|subtitle|
              f.checkboxes("subtitles[]").find {|checkbox|
                checkbox.node.at("following-sibling::label").inner_text == subtitle
              }.check
            }
          }.submit

          # error
          if ret.uri.path =~ %~^/upload.php~
            errors = ret.search("//*[class='bvalidator_errmsg']")
            msg = errors.map{|e| "- #{ReverseMarkdown.parse(e)}" }.join("\n\n")
            Saber.ui.error "ERROR:\n #{msg}"
            return false
          else
            return true
          end
        }
      end

    protected

      def do_login_with_username
        agent.get("/login.php") { |p|
          ret = p.form_with(action: "login.php" ) {|f|
            # error
            unless f 
              Saber.ui.error! p.at("//body").inner_html
            end

            f.username = username || ask("Username: ")
            f.password = ask("Password: "){|q| q.echo = false}
            f.checkbox(name: "keeplogged").check
          }.submit

          # error
          if ret.uri.path == "/login.php"
            msg = ret.at("//*[@id='loginfail']/p[1]").inner_text
            Saber.ui.error "Faild. #{msg}"
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
