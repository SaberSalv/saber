require "active_support/core_ext/string/inflections"

module Saber
  module Tracker2
    class Base
      def self.inherited(child)
        return if [Gazelle].include?(child)

        Tracker2.trackers[child.name.demodulize.underscore] = child
      end

      # Implement
      BASE_URL = ""
      TYPES = {}

      attr_reader :agent, :name, :options
      
      def initialize(options={})
        @name = self.class.name.demodulize.underscore
        @options = options
        @agent = Watir::Browser.new(*Rc.browser)
        @agent.keep_cookies!
        @error_counts = 0
      end

      def upload(format, filename, yaml_file, torrent_file, o={})
        info0 = YAML.load_file(yaml_file)
        is_archived = torrent_file.to_s.start_with?("#{name}/")

        # current release only support ebook type.
        Saber.ui.error "Current doesn't support this upload_type -- #{info0['upload_type']}." unless 
          %w[ebook magazine journal newspaper manual article comic].include? info0["upload_type"]

        info = {}

        # convert {"tracker.tags" => x} to {"trackers" => {"tags" => x}}
        info0.each {|k, v|
          if k.include?(".")
            tracker, key = k.split(".")
            info[tracker] ||= {}
            info[tracker][key] = v
          elsif Hash === info[k] and Hash === v
            info[k].merge!(v)
          else
            info[k] = v
          end
        }

        info.deep_symbolize_keys!
        info[:format] = format.upcase
        info[:upload_type2] = self.class::TYPES[info[:upload_type]] 
        info[:torrent_file] = Pa.absolute2(torrent_file)
        info.merge! info.delete(name.to_sym){ {} }
        
        # skip empty description.
        if info[:description].empty?
          Saber.ui.error "SKIP: Empty description -- #{yaml_file}"
          return
        end

        # check exists?
        if Tracker[name].respond_to?(:exists?) 
          tracker = Tracker[name].new
          tracker.login
          if tracker.exists?(isbn: info[:isbn])
            Saber.ui.say "SKIP: File existing in #{name} site. -- (#{info[:isbn]}) #{info[:title]}"
            return
          end
        end

        process_info!(info)
        upload_method = o[:add] ? :add_format : :new_upload
        if send(upload_method, info)
          Saber.ui.say "Upload Complete: #{filename}"

          # archive
          if !is_archived and Rc._has_key?("upload.archive")
            archive = case (archive=Rc.upload.archive)
            when Proc
              archive.call(info[:upload_type])
            else
              archive
            end

            Pa.mv yaml_file, archive, mkdir: true
            Pa.mv torrent_file, "#{archive}/#{name}", mkdir: true
          end

        else
          @error_counts += 1
          Saber.ui.error "SKIP: Upload failed -- #{filename}"
        end
      end

      def exit
        agent.exit if @error_count == 0 
      end

    protected

      # check login and save cookies
      def check_login(url_pat)
        #unless agent.url =~ url_pat
        #  agent.wait_until { agent.url =~ url_pat }
        #  agent.cookies.dump("#{Rc.p.home}/#{name}.cookies")
        #end
        
        agent.wait_until { agent.url =~ url_pat }
      end

      # Implement
      #
      # Upload one torrent file to the site.
      #
      # @param [Optimism] info comes from <file>.yml data file.
      #
      # @return [Boolean] result-code
      def new_upload(info)
        raise NotImplementedError
      end

      # Implement
      #
      # Upload via add formt
      #
      def add_format(info)
        raise NotImplementedError
      end

      def process_info!(info)
        info
      end
    end
  end
end

# vim: fdn=4
