module Saber
  module Tracker
    class What < Gazelle
      BASE_URL = "https://what.cd"
      LOGIN_CHECK_PATH = "/inbox.php"

      FIELDS = { 
        "E-Books" => { 
          "file_input" => :file_upload,
          "type" => :select_list,
          "title" => :text,
          "tags" => :text,
          "image" => :text,
          "desc" => :text
        }
      }
      
    protected

      def do_login_with_username(username)
        agent.get("/login.php") {|p|
          ret = p.form_with(action: "login.php" ) {|f|
            # error
            unless f 
              Saber.ui.error! p.at("//body").inner_text
            end

            f.username = username || ask("Username: ")
            f.password = ask("Password: "){|q| q.echo = false}
            f.checkbox(name: "keeplogged").check
          }.submit

          # error
          if ret.uri.path == "/login.php"
            msg = ret.at("//*[@id='loginform']/span[2]").inner_text
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
