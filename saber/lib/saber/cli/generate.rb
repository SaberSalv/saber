module Saber
  class CLI
    include Thor::Actions

    def self.source_paths
      ["#{Rc.p.home}/templates"]
    end

    source_root "#{Rc.p.root}/templates"

    desc "generate [options] <type> [filename:isbn ...]", %~generate a meta data file (alias: "g")~
    method_option "file", aliases: "-f", desc: "read files from file list", type: :string
    def generate(type, *filenames)
      filenames = File.read(options["file"]).split(/\n+/).map{|v| v.strip} if options["file"]
      filenames = filenames.map{|v| name, isbn = v.split(":"); [*strip_filenames(name), isbn]}
      template_file = find_in_source_paths("#{type}.yml")

      filenames.each {|filename, isbn|
        isbn = ISBN.thirteen(isbn) rescue nil
        Saber.ui.say "Populating {#{isbn}} #{filename} ..."
        dest = "#{filename}.yml" 

        if isbn
          populate = {}
          data = YAML.load_file(template_file)
          data.merge! Book.populate(isbn, filename)
          data.merge! YAML.load_file("#{Rc.p.database}/#{isbn}.yml") if Pa.exists?("#{Rc.p.database}/#{isbn}.yml")

          # tags
          if data["tags"]
            Tracker.trackers.each {|name, tracker_class|
              if data["#{name}.tags"].nil? and tracker_class.method_defined?(:convert_tags)
                tracker = tracker_class.new(options)
                data["#{name}.tags"] = tracker.convert_tags(*data["tags"].split(/, */)).join(", ")
              end
            }
          end

          create_file dest, YAML.dump(data)
        else
          copy_file template_file, dest
        end
      }
    end
    map "g" => "generate"
  end
end
