require "tagen/core/array/extract_options"

module Rake # ::Pipeline::FileWrapper
  class Pipeline
    class FileWrapper
      def readline
        if "".respond_to?(:encode)
          @file ||= File.open(fullpath, :encoding => encoding)
        else
          @file ||= File.open(fullpath)
        end

        line = @file.readline

        if "".respond_to?(:encode) && !line.valid_encoding?
          raise EncodingError, "The file at the path #{fullpath} is not valid UTF-8. Please save it again as UTF-8."
        end

        line
      end
    end
  end
end

module MyFilters
  class MetaFilter < Rake::Pipeline::Filter
    attr_reader :options

    def initialize(fname=nil, o={}, &blk)
      blk = proc { fname } if fname
      super &blk
      @options = o
    end


    def generate_output(inputs, output)
      inputs.each do |input|
        ret = ""
        while (line=input.readline)
          ret << line
          break if line =~ %r~==/UserScript==~
        end

        output.write ret
      end
    end
  end

  module Helpers
    # @overload meta(fname, o={}){}
    # @overload meta(o={}){}
    def meta(*args, &blk)
      (fname,), o = args.extract_options
      filter MyFilters::MetaFilter, fname, o, &blk
    end
  end
end

module Neuter

  DEBUG = false

  class SpadeWrapper < Rake::Pipeline::FileWrapper
    
    REQUIRE_RE = %r{^\s*require\(['"]([^'"]*)['"]\);?\s*}

    def initialize(root=nil, path=nil, encoding="UTF-8", o={})
      super(root, path, encoding)
      @options = o

      # Keep track of required files
      @required = []
    end

    def read
      source = super

      # Replace all requires with emptiness, and accumulate dependency sources
      prepend = ''
      source.gsub! REQUIRE_RE do |m|
        req = $1

        # Find a reason to fail
        reason = @required.include?(req) ? 'Already required' : false
        reason ||= is_external_req(req) ? "External package  - #{req}" : false

        if reason
          puts "DEBUG Skipped #{req} required in #{path} (#{reason})" if DEBUG
        else
          @required << req
          req_file = File.join("#{req}.js")
          prepend = prepend + self.class.new(root, req_file, encoding, @options).read
          puts "DEBUG Required #{req_file} as #{req} in #{path}" if DEBUG
        end
        ''
      end

      source = "(function() {\n#{source}\n})();\n\n" unless @options[:bare]
      "#{prepend}#{source}"
    end

    protected

    #  not require "./foo"
    def is_external_req(req)
      not req.match(%~^\./~)
    end
  end

  module Filters

    class NeuterFilter < Rake::Pipeline::ConcatFilter

      # Allows selective concat by passing packages array (or all if nil)
      def initialize(fname=nil, o={}, &block)
        @file_wrapper_class = SpadeWrapper unless o[:bare]
        super(fname, &block)
        @options = o
      end

      def generate_output(inputs, output)
        inputs.each do |input|
          next unless input.path == "main.js"

          spade = SpadeWrapper.new(input.root, input.path, input.encoding, @options)
          p "Neutering #{input.path} into #{output.path}" if DEBUG
          output.write spade.read          
        end
      end
    end

    class SelectFilter < Rake::Pipeline::ConcatFilter

      # Allows selective concat by passing packages array (or all if nil)
      def initialize(fname=nil, &block)
        super(fname, &block)
      end

      def generate_output(inputs, output)
        inputs.each do |input|
          next unless @packages.include?(input.path)
          output.write input.read
        end
      end
    end
  end

  module Helpers
    # @overload neuter(fname, o={})
    #   @param [Hash] o options
    #   @option o [Boolean] :bare (false) don't wrap
    def neuter(*args, &block)
      filter(Neuter::Filters::NeuterFilter, *args, &block)
    end

    def select(*args, &block)
      filter(Neuter::Filters::SelectFilter, *args, &block)
    end
  end
end

Rake::Pipeline::DSL::PipelineDSL.send(:include, Neuter::Helpers)
Rake::Pipeline::DSL::PipelineDSL.send(:include, MyFilters::Helpers)
