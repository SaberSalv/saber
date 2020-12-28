module Saber
  module Tv
    class Naming
      attr_reader :filename, :name, :season, :episode

      def initialize(filename)
        @filename = filename
        @name, @season, @episode = Parser.new.parse(filename)
      end

      def to_s
        "#{@name} #{@season}x#{@episode}"
      end
    end
  end
end

require "saber/tv/naming/parser"
