require "active_support/core_ext/string/inflections"

module Saber
  module Tracker
    class Base
      DELEGATE_METHODS = [:get]

      def self.inherited(child)
        return if [Gazelle].include?(child)

        Tracker.trackers[child.name.demodulize.underscore] = child
      end

      class << self
        attr_reader :tracker_name

        def tracker_name
          @tracker_name ||= self.name.demodulize.underscore
        end
      end

      # implement
      POPULATE_TYPES = []

      def self.can_populate?(type)
        self::POPULATE_TYPES.include?(type.to_s)
      end

      # implement
      BASE_URL = ""
      LOGIN_CHECK_PATH = ""

      attr_reader :agent, :name, :options

      def initialize(options={})
        @options = options
        @agent = Mechanize.new 
      end

      def name
        self.class.tracker_name
      end

      def login
        @agent.get(self.class::BASE_URL)

        if login_with_cookie
          return
        end

        login_with_username

        Saber.ui.say "Login succesfully."
      end

      def upload(*torrent_files)
        files = torrent_files.map{|v| Pa.delete_ext(v, ".torrent")}

        files.each {|file|
          info = Optimism.require!("./#{file}.yml")

          if do_upload(file, info)
            Saber.ui.say "Upload Complete: #{file}"
          else
            Saber.ui.error "Upload Failed: #{file}"
          end
        }
      end

      # Return data by auto-fill functions provied by site.
      #
      # @example
      #
      #  populate("ebook", isbn)
      #
      # @return [Hash]
      def populate(type, *args)
        meth = "populate_#{type}"

        if respond_to?(meth) then
          send meth, *args
        else
          raise ArgumentError, "Not support this type -- #{type}"
        end
      end

      DELEGATE_METHODS.each {|mth|
        eval <<-EOF
          def #{mth}(*args, &blk)
            agent.#{mth}(*args, &blk)
          end
        EOF
      }

    protected

      # Implement
      #
      # @return [Boolean] success?
      def do_upload(file, info)
        raise NotImplementedError
      end

      # Implement
      #
      # @return [Boolean] success?
      def do_login_with_username(username)
        raise NotImplementedError
      end

      def login_with_cookie
        if Pa.exists?("#{Rc.p.home}/#{name}.cookies") then
          open("#{Rc.p.home}/#{name}.cookies") { |io|
            agent.cookie_jar.load_cookiestxt(io)
          }

          ret = agent.get(self.class::LOGIN_CHECK_PATH)

          if ret.uri.path == self.class::LOGIN_CHECK_PATH
            true 
          else
            Saber.ui.say "Login with cookie failed."
            false
          end
        end
      end

      def login_with_username
        username = Rc._fetch(["#{name}.username", "username"], nil)

        Saber.ui.say "Begin to login #{name} manually."
        Saber.ui.say "Username: #{username}" if username
        loop do
          if do_login_with_username(username)
            open("#{Rc.p.home}/#{name}.cookies", "w") { |f|
              agent.cookie_jar.dump_cookiestxt(f)
            }
            return true
          end
        end
      end
    end
  end
end

# vim: fdn=4
