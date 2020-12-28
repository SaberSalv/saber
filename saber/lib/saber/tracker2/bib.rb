module Saber
  module Tracker2
    class BIB < Base
      BASE_URL = "http://bibliotik.org"

      TYPES = {
        "application" => "applications",
        "article" => "articles",
        "audiobook" => "audiobooks",
        "comic" => "comics",
        "ebook" => "ebooks",
        "journal" => "journals",
        "magazine" => "magazines"
      }

      FIELDS = { 
        "application" => {
          torrent_file: "//input[@name='TorrentFileField']",
          scene: "//input[@name='SecneField']",
          title: "//input[@name='TitleField']",
          tags: "//input[@name='TagsField']",
          image: "//input[@name='ImageField']",
          description: "//textarea[@name='DescriptionField']",
          anonymous: "//input[@name='AnonymousField']",
          notify: "//input[@name='NotifyField']"
        },

        "article" => {
          torrent_file: "//input[@name='TorrentFileField']",
          authors: "//input[@name='AuthorsField']", 
          title: "//input[@name='TitleField']",
          pages: "//input[@name='PagesField']",
          year: "//input[@name='YearField']",
          yearto: "//input[@name='YearToField']",
          complete: "//input[@name='CompleteField']",
          format: "//select[@name='FormatField']",
          language: "//select[@name='LanguageField']",
          tags: "//input[@name='TagsField']",
          image: "//input[@name='ImageField']",
          description: "//textarea[@name='DescriptionField']",
          anonymous: "//input[@name='AnonymousField']",
          notify: "//input[@name='NotifyField']"
        },

        "autobook" => {
          torrent_file: "//input[@name='TorrentFileField']",
          authors: "//input[@name='AuthorsField']", 
          title: "//input[@name='TitleField']",
          isbn: "//input[@name='IsbnField']",
          publisher: "//input[@name='PublishersField']",
          year: "//input[@name='YearField']",
          format: "//select[@name='FormatField']",
          language: "//select[@name='LanguageField']",
          tags: "//input[@name='TagsField']",
          image: "//input[@name='ImageField']",
          description: "//textarea[@name='DescriptionField']",
          anonymous: "//input[@name='AnonymousField']",
          notify: "//input[@name='NotifyField']"
        },

        "comic" => {
          torrent_file: "//input[@name='TorrentFileField']",
          authors: "//input[@name='AuthorsField']", 
          artists: "//input[@name='ArtistsField']", 
          title: "//input[@name='TitleField']",
          publisher: "//input[@name='PublishersField']",
          pages: "//input[@name='PagesField']",
          year: "//input[@name='YearField']",
          yearto: "//input[@name='YearToField']",
          complete: "//input[@name='CompleteField']",
          format: "//select[@name='FormatField']",
          language: "//select[@name='LanguageField']",
          tags: "//input[@name='TagsField']",
          image: "//input[@name='ImageField']",
          description: "//textarea[@name='DescriptionField']",
          anonymous: "//input[@name='AnonymousField']",
          notify: "//input[@name='NotifyField']"
        },

        "ebook" => {
          torrent_file: "//input[@name='TorrentFileField']",
          authors: "//input[@name='AuthorsField']", 
          title: "//input[@name='TitleField']",
          isbn: "//input[@name='IsbnField']",
          publisher: "//input[@name='PublishersField']",
          pages: "//input[@name='PagesField']",
          year: "//input[@name='YearField']",
          format: "//select[@name='FormatField']",
          language: "//select[@name='LanguageField']",
          retail: "//input[@name='RetailField']",
          tags: "//input[@name='TagsField']",
          image: "//input[@name='ImageField']",
          description: "//textarea[@name='DescriptionField']",
          anonymous: "//input[@name='AnonymousField']",
          notify: "//input[@name='NotifyField']"
        },

        "journal" => {
          torrent_file: "//input[@name='TorrentFileField']",
          title: "//input[@name='TitleField']",
          pages: "//input[@name='PagesField']",
          year: "//input[@name='YearField']",
          yearto: "//input[@name='YearToField']",
          complete: "//input[@name='CompleteField']",
          format: "//select[@name='FormatField']",
          language: "//select[@name='LanguageField']",
          tags: "//input[@name='TagsField']",
          image: "//input[@name='ImageField']",
          description: "//textarea[@name='DescriptionField']",
          anonymous: "//input[@name='AnonymousField']",
          notify: "//input[@name='NotifyField']"
        },

        "magazine" => {
          torrent_file: "//input[@name='TorrentFileField']",
          title: "//input[@name='TitleField']",
          pages: "//input[@name='PagesField']",
          year: "//input[@name='YearField']",
          yearto: "//input[@name='YearToField']",
          complete: "//input[@name='CompleteField']",
          format: "//select[@name='FormatField']",
          language: "//select[@name='LanguageField']",
          tags: "//input[@name='TagsField']",
          image: "//input[@name='ImageField']",
          description: "//textarea[@name='DescriptionField']",
          anonymous: "//input[@name='AnonymousField']",
          notify: "//input[@name='NotifyField']"
        }
      }
      
      def new_upload(info)
        agent.goto "#{BASE_URL}/upload/#{info[:upload_type2]}"
        check_login %r~/upload/#{info[:upload_type2]}~ 

        form = agent.form(action: "")

        FIELDS[info[:upload_type]].each {|key, selector|
          form.set2(selector, info[key])
        }

        form.submit()

        if agent.url =~ %r~/upload/#{info[:upload_type2]}~
          err = agent.element(xpath: "//*[@id='formerrorlist']")
          msg = err.exists? ? ReverseMarkdown.parse(err.html) : agent.text
          Saber.ui.error "ERROR: #{msg.to_s.strip}\n"
          return false 
        else
          return true
        end
      end

      def process_info!(info)
        info[:complete] = (info[:type] == "Pack")
        info[:description] = "#{info[:release_description].strip}\n\n#{info[:description]}"
      end
    end
  end
end

# vim: fdn=4
