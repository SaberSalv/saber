=begin
require "spec_helper"
require "saber/tracker/bib"

BIB = Saber::Tracker::BIB

describe BIB do
  it do
    VCR.use_cassette("bib", record: :new_episodes) do
    #VCR.use_cassette("bib", record: :all) do
      a = Mechanize.new
      #a.get "http://www.google.com"
      #ret = a.get "http://www.g.cn"
      #a.get "http://bibliotik.org/"
      #ret = a.get "http://bibliotik.org/login"
      #ret = a.get "http://what.cd/"
      #pd ret.uri

      bib = BIB.new
      bib.login
    end
  end
end
=end
