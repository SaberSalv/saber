#!/usr/bin/env ruby
require "fileutils"
require "mkmf"

bindir = File.expand_path("../bin", __FILE__)

gem_home = if Gem.dir.match(%~/(\.rvm|\.rbenv)/~)
    Gem.dir
  elsif Process.pid == 0
    Gem.dir
  else
    Gem.user_dir
  end
dist_bindir = ENV["GEM_BINDIR"] || Gem.bindir(gem_home)

FileUtils.install File.join(bindir, "saber-drb_add"), dist_bindir
FileUtils.install File.join(bindir, "saber.bib"), dist_bindir
FileUtils.install File.join(bindir, "saber.bb"), dist_bindir
FileUtils.install File.join(bindir, "saber.stp"), dist_bindir
FileUtils.install File.join(bindir, "saber.what"), dist_bindir
FileUtils.install File.join(bindir, "saber.trakt"), dist_bindir

create_makefile("saber")
