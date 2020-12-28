module Saber
  module Tracker2
    class STP < Gazelle
      BASE_URL = "https://stopthepress.es"

      TYPES = {
        "magazine" => "Magazines",
        "newspaper" => "Newspapers",
        "manual" => "Manuals",
        "journal" => "Journals",
        "ebook" => "E-Books"
      }

      FIELDS = { 
        "magazine" => {
          torrent_file: "//input[@name='file_input']",
          name: "//input[@name='artists[]']",
          title: "//input[@name='title']",
          type: "//select[@name='releasetype']",
          edition: "//input[@name='remaster_title']",
          scene: "//input[@name='scene']",
          format: "//select[@name='format']",
          source: "//select[@name='media']",
          retail: "//input[@name='flac_log']",
          tags: "//input[@name='tags']",
          image: "//input[@name='image']",
          description: "//textarea[@name='album_desc']",
          release_description: "//textarea[@name='release_desc']"
        },

        "newspaper" => {
          torrent_file: "//input[@name='file_input']",
          title: "//input[@name='title']",
          tags: "//input[@name='tags']",
          image: "//input[@name='image']",
          description: "//textarea[@name='desc']"
        },

        "manual" => {
          torrent_file: "//input[@name='file_input']",
          title: "//input[@name='title']",
          tags: "//input[@name='tags']",
          image: "//input[@name='image']",
          description: "//textarea[@name='desc']"
        },

        "journal" => {
          torrent_file: "//input[@name='file_input']",
          title: "//input[@name='title']",
          tags: "//input[@name='tags']",
          image: "//input[@name='image']",
          description: "//textarea[@name='desc']"
        },

        "ebook" => {
          torrent_file: "//input[@name='file_input']",
          title: "//input[@name='title']",
          publisher: "//input[@name='record_label']",
          isbn: "//input[@name='catalogue_number']",
          year: "//input[@name='year']",
          #edition: "//input[@name='remaster_title']",
          #edition_year:  "//input[@name='remaster_year']",
          #edition_publisher: "//input[@name='remaster_record_label']",
          #edition_isbn: "//input[@name='remaster_catalogue_number']",
          scene: "//input[@name='scene']",
          format: "//select[@name='format']",
          source: "//select[@name='media']",
          retail: "//input[@name='flac_log']",
          tags: "//input[@name='tags']",
          image: "//input[@name='image']",
          description: "//textarea[@name='album_desc']",
          release_description: "//textarea[@name='release_desc']"
        },
      }

      ADD_FIELDS = {
        "ebook" => {
          torrent_file: "//input[@name='file_input']",
          edition: "//input[@name='remaster_title']",
          year:  "//input[@name='remaster_year']",
          publisher: "//input[@name='remaster_record_label']",
          isbn: "//input[@name='remaster_catalogue_number']",
          scene: "//input[@name='scene']",
          format: "//select[@name='format']",
          source: "//select[@name='media']",
          retail: "//input[@name='flac_log']",
          release_description: "//textarea[@name='release_desc']"
        },
      }

      def fill_add_form(form, info)
        # ebook: edition
        if %w[ebook].include? info[:upload_type]
          form.checkbox(name: "remaster").set(true)
        end

        ADD_FIELDS[info[:upload_type]].each {|key, selector|
          form.set2(selector, check_value!(info[key]))
        }
      end

      def fill_form(form, info)
        form.select(name: "type").select info[:upload_type2]
        form.input(name: "artists[]").wait_while_present unless info[:upload_type] == "magazine"
        sleep 0.1

        # magazine. edition
        if %[magazine].include? info[:upload_type]
          form.checkbox(name: "remaster").set(true)
        end

        # edition, authors
        if %w[ebook].include? info[:upload_type]
          #form.checkbox(name: "remaster").set(true)

          (info[:authors].split(",").length - 1).times { 
            form.a(text: '+').click 
          }
        end

        FIELDS[info[:upload_type]].each {|key, selector|
          form.set2(selector, info[key])
        }

        # authors
        if %w[ebook].include? info[:upload_type]
          info[:authors].split(",").each.with_index { |author, i|
            form.text_fields(name: "authors[]")[i].set author
          }
        end
      end
    end
  end
end

# vim: fdn=4
