require "active_support/core_ext/object/try"

module Saber
  module Tracker
    class BIB < Base
      POPULATE_TYPES = %w[ebook audiobook]
      BASE_URL = "http://bibliotik.org"
      LOGIN_CHECK_PATH = "/conversations"

      FIELDS = { 
        "applications" => {
          "TorrentFile" => :file_upload,
          "Scene" => :checkbox,
          "Title" => :text,
          "Tags" => :text,
          "Image" => :text,
          "Description" => :text,
          "Anonymous" => :checkbox,
          "Notify" => :checkbox,
        },

        "articles" => {
          "TorrentFile" => :file_upload,
          "Authors" => :text,
          "Title" => :text,
          "Pages" => :text,
          "Year" => :text,
          "YearTo" => :text,
          "Complete" => :checkbox,
          "Format" => :text,
          "Language" => :text,  
          "Tags" => :text,
          "Image" => :text,
          "Description" => :text,
          "Anonymous" => :checkbox,
          "Notify" => :checkbox,
        },


        "autobooks" => {
          "TorrentFile" => :file_upload, 
          "Authors" => :text,
          "Title" => :text,
          "ISBN" => :text,
          "Publishers" => :text,
          "Year" => :text,
          "Format" => :select_list_text,
          "Language" => :select_list_text,
          "Tags" => :text,
          "Image" => :text,
          "Description" => :text,
          "Anonymous" => :checkbox,
          "Notify" => :checkbox,
        },

        "comics" => {
          "TorrentFile" => :file_upload, 
          "Scene" => :checkbox,
          "Authors" => :text,
          "Artists" => :text,
          "Title" => :text,
          "Publishers" => :text,
          "Pages" => :text,
          "Year" => :text,
          "YearTo" => :text,
          "Complete" => :checkbox,
          "Format" => :select_list_text,
          "Language" => :select_list_text,
          "Tags" => :text,
          "Image" => :text,
          "Description" => :text,
          "Anonymous" => :checkbox,
          "Notify" => :checkbox,
        },

        "ebooks" => {
          "TorrentFile" => :file_upload, 
          "Scene" => :checkbox,
          "Authors" => :text, 
          "Title" => :text,
          "ISBN" => :text,
          "Publishers" => :text,
          "Pages" => :text,
          "Year" => :text,
          "Format" => :select_list_text,
          "Language" => :select_list_text,
          "Retail" => :checkbox,
          "Tags" => :text,
          "Image" => :text,
          "Description" => :text,
          "Anonymous" => :checkbox,
          "Notify" => :checkbox,
        },

        "journals" => {
          "TorrentFile" => :file_upload, 
          "Scene" => :checkbox,
          "Title" => :text,
          "Pages" => :text,
          "Year" => :text,
          "YearTo" => :text,
          "Complete" => :checkbox,
          "Format" => :select_list_text,
          "Language" => :select_list_text,
          "Tags" => :text,
          "Image" => :text,
          "Description" => :text,
          "Anonymous" => :checkbox,
          "Notify" => :checkbox,
        },

        "magazines" => {
          "TorrentFile" => :file_upload, 
          "Scene" => :checkbox,
          "Title" => :text,
          "Pages" => :text,
          "Year" => :text,
          "YearTo" => :text,
          "Complete" => :checkbox,
          "Format" => :select_list_text,
          "Language" => :select_list_text,
          "Tags" => :text,
          "Image" => :text,
          "Description" => :text,
          "Anonymous" => :checkbox,
          "Notify" => :checkbox,
        }
      }
      
      # Upload one torrent file to the site.
      #
      # @param [String] file a filename
      # @param [Optimism] info comes from <file>.yml data file.
      #
      # @return [Boolean] result-code
      def do_upload(file, info)
        info["TorrentFile"] = "#{file}.torrent"

        agent.get("/upload/#{info.type}") {|p|
          ret = p.form_with(action: "") {|f|
            FIELDS[info.type].each {|k,t|
              f.set(t, "#{k}Field", info[k])
            }
          }.submit

          # error if return path is "/upload/<type>"
          if ret.uri.path == "/upload/#{info.type}"
            msg = nil
            if (err=ret.at("//*[@id='formerrorlist']"))
              # convert html to markdown for pretty print.
              msg = ReverseMarkdown.parse(err)
            else
              msg = ret.body
            end
            Saber.ui.error "ERROR:\n#{msg}"
            return false
          else
            return true
          end
        }
      end

      def browse(page, &blk)
        ret = []
        path = "/torrents/advanced/?search=&cat[0]=5&y1=&y2=&p1=&p2=&size1=&size2=&for[0]=15&orderby=added&order=desc&page=#{page}"

        p = agent.get(path) 
        p.search("//td[contains(string(), '[Retail]')]/span[@class='title']/a").each {|a|
          page = agent.get(a["href"])

          title = page.at("//*[@id='title']").inner_text.strip
          tags = page.search("//*[@class='taglist']/a").map{|n| n.inner_text}
          isbn = page.at("//*[@id='details_content_info']").inner_text.match(/\((\d+)\)/).try(:[], 1) || ""
          download_link = page.at("//*[@id='details_links']/a[@title='Download']")["href"]
          filenames = page.search("//*[@id='files']//td[1]").map{|n| n.inner_text}

          torrent = {title: title, tags: tags, isbn: isbn, download_link: download_link, filenames: filenames}
          blk.call(torrent) if blk
          ret << torrent
        }

        ret
      end

      def convert_tags(*tags)
        tags
      end

    protected

      # Attpened to login the site with username and password. this happens 
      # after login failed with cookie. 
      def do_login_with_username(username)
        agent.get("/login") {|p|
          ret = p.form_with(action: "login" ) {|f|
            # error. e.g. temporary disabled for failed logining exceed maxmium count.
            unless f 
              # print error in red color and exit the program.
              Saber.ui.error! p.at("//body").inner_text
            end

            f.username = username || ask("Username: ")
            f.password = ask("Password: "){|q| q.echo = false}
            f.checkbox(name: "keeplogged").check
          }.submit

          # error
          if ret.uri.path == "/login"
            msg = ret.at("//body/center").inner_text
            Saber.ui.error "Failed. #{msg}"
            return false
          else
            return true
          end
        }
      end

      def populate_ebook(isbn)
        populate_isbn("ebooks", isbn)
      end

      def populate_audiobook(isbn)
        populate_isbn("audiobooks", isbn)
      end

      def populate_isbn(type, isbn)
        headers = {"X-Requested-With" => "XMLHttpRequest", "Content-Type" => "application/json; charset=utf-8", "Accept" => "application/json, text/javascript, */*"}
        page = agent.get("/upload/#{type}")
        authkey = page.at("//input[@name='authkey']")["value"]

        params = {isbn: isbn, authkey: authkey}
        ret = JSON.parse(agent.get("/isbnlookup", params, nil, headers).body)

        if ret["error"]
          Saber.ui.error "Populate Failed. #{ret['error']}"
          {}
        else
          Hash[ret.map{|k, v| [(k=="publisher" ? "publishers" : k).capitalize, v]}]
        end
      end
    end
  end
end

# vim: fdn=4
