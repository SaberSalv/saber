module Saber
  module Tracker
    class STP < Gazelle
      BASE_URL = "https://stopthepress.es"
      LOGIN_CHECK_PATH = "/inbox.php"

      def exists?(o={})
        url = "/torrents.php?cataloguenumber=#{o[:isbn]}"
        page = agent.get(url)

        not page.at("//*[@id='content']/div[2]/h2[contains(text(), 'Your search did not match anything.')]")
      end

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
