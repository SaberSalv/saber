module Saber
  class UI
    def initialize
      @quiet = false
      @debug = ENV["DEBUG"]
    end

    def info(msg)
      do_info(msg) if !@quiet
    end

    def debug(msg)
      do_debug(msg) if @debug && !@quiet
    end

    def warn(msg)
      do_warn(msg)
    end

    def error(msg)
      do_error(msg)
    end

    # error with exit
    def error!(msg)
      error(msg)
      exit 1
    end

    def confirm(msg)
      do_confirm(msg) if !@quiet
    end

    def say(msg)
      info(msg)
    end

    def be_quiet!
      @quiet = true
    end

    def debug!
      @debug = true
    end

    class Shell < UI
      attr_writer :shell

      def initialize(shell)
        super()
        @shell = shell
      end

      def do_info(msg)
        @shell.say(msg) if !@quiet
      end

      def do_debug(msg)
        @shell.say(msg) if @debug && !@quiet
      end

      def do_warn(msg)
        @shell.say(msg, :yellow)
      end

      def do_error(msg)
        @shell.say(msg, :red)
      end

      def do_confirm(msg)
        @shell.say(msg, :green) if !@quiet
      end
    end

    class Logger < UI
      attr_accessor :logger

      def initialize(logger)
        super()
        @logger = logger
      end

      def do_debug(msg)
        @logger.debug(msg)
      end

      def do_info(msg)
        @logger.info(msg)
      end

      def do_confirm(msg)
        @logger.confirm(msg) 
      end

      def do_warn(msg)
        @logger.warn(msg)
      end

      def do_error(msg)
        @logger.error(msg)
      end
    end
  end
end
