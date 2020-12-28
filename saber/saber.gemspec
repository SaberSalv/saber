Kernel.load File.expand_path("../lib/saber/version.rb", __FILE__)

spec = Gem::Specification.new do |s|
	s.name = "saber"
	s.version = Saber::VERSION
	s.summary = "A complete solution for PT users."
	s.description = <<-EOF
A complete solution for PT users.
	EOF

	s.author = "SaberSalv"
	s.email = "sabersalv@gmail.com"
	s.homepage = "http://github.com/SaberSalv/saber"
	s.rubyforge_project = "xx"

	s.files = `git ls-files`.split("\n")
	s.executables = ["saber"]
  s.extensions << "extconf.rb"

	s.add_dependency "pd", ">= 0"
	s.add_dependency "tagen", "~> 2.0.1"
	s.add_dependency "optimism", "~> 3.3.1"
	s.add_dependency "pa", "~> 1.3.3"
	s.add_dependency "retort", "~> 0.0.6"
	s.add_dependency "thor", "~> 0.16.0"
	s.add_dependency "net-ssh", "~> 2.5.2"
	s.add_dependency "blather", "~> 0.8.0"
	s.add_dependency "mechanize", "~> 2.5.1"
	s.add_dependency "highline", "~> 1.6.14"
	s.add_dependency "reverse_markdown", "~> 0.3.0"
	s.add_dependency "watir", "~> 4.0.1"
	s.add_dependency "faraday", "~> 0.8.4"
	s.add_dependency "faraday_middleware", "~> 0.8.8"
	s.add_dependency "isbn", "~> 2.0.7"
	s.add_dependency "sys-filesystem", "~> 1.0.0"
end
