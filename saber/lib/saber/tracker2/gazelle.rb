module Saber
  module Tracker2
    class Gazelle < Base
      def add_format(info)
        unless info[:groupid]
          Saber.ui.error "You must provide a groupid -- #{info[:groupid].inspect}" 
          return false 
        end

        agent.goto "#{self.class::BASE_URL}/upload.php?groupid=#{info[:groupid]}"
        check_login %r~/upload\.php~

        form = agent.form(action: "")
        fill_add_form(form, info)
        form.submit() unless options["dry-run"]

        if agent.url =~ %r~/upload\.php~
          err = agent.element(xpath: "//*[@id='content']/div[2]/p[2]")
          msg = err.exists? ? ReverseMarkdown.parse(err.html).strip : "" 
          Saber.ui.error "ERROR: #{msg}\n"
          return false 
        else
          return true
        end
      end

      def new_upload(info)
        agent.goto "#{self.class::BASE_URL}/upload.php"
        check_login %r~/upload\.php~

        form = agent.form(action: "")
        fill_form(form, info)
        form.submit() unless options["dry-run"]

        if agent.url =~ %r~/upload\.php~
          err = agent.element(xpath: "//*[@id='content']/div[2]/p[2]")
          msg = err.exists? ? ReverseMarkdown.parse(err.html).strip : "" 
          Saber.ui.error "ERROR: #{msg}\n"
          return false 
        else
          return true
        end
      end
    end
  end
end
