require "pd"
require "logger"
require "saber"

$spec_dir = File.expand_path("..", __FILE__)
$spec_data = File.join($spec_dir, "data")
$spec_tmp = File.join($spec_dir, "tmp")

Rc = Saber::Rc
Rc._merge Optimism <<EOF
p:
  home = Pa("#{$spec_data}/_saber")
  homerc = Pa("#{$spec_data}/_saberrc")
  watch = nil
  remote_watch = nil
  fetcher_download = Pa("#{$spec_data}/download")
  remote_download = Pa("#{$spec_data}/remote_bt")
  download = Pa("#{$spec_data}/remote_bt")

server:
  ftp = "ftp://seedbox/bt"
  host = "localhost"
  user = "foo"

# upload

username = "username"

bib:
  username = "bib-username"
  announce_url = "bib-announce_url"
EOF
$log = Logger.new(StringIO.new)

require "thor"
Saber.ui = Saber::UI::Shell.new(Thor.new.shell)

require "vcr"
VCR.configure do |c|
  c.cassette_library_dir = "spec/cassettes"
  c.hook_into :webmock
end

RSpec.configure do |config|
  def capture(stream=:stdout)
		require "stringio"
    begin
      stream = stream.to_s
      eval "$#{stream} = StringIO.new"
      yield
      result = eval("$#{stream}").string
    ensure
      eval("$#{stream} = #{stream.upcase}")
    end

    result
  end

  alias :silence :capture
end

module RSpec
  module Core
    module DSL
      def xdescribe(*args, &blk)
        describe *args do
          pending 
        end
      end

      alias xcontext xdescribe
    end
  end
end

def public_all_methods(*klasses)
	klasses.each {|klass|
		klass.class_eval {
      public *(self.protected_instance_methods(false) + self.private_instance_methods(false))
      public_class_method *(self.protected_methods(false) + self.private_methods(false))
    }
	}
end
