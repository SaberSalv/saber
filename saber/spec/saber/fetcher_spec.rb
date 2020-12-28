require "spec_helper"

Fetcher = Saber::Fetcher

uri="a.mkv"

xdescribe Fetcher do
  describe "test everyting" do
    it "works" do
     XMLRPC::Client.stub(:new2)

     d = Fetcher.new

     d.should_receive(:aria2_add).with(["ftp://seedbox/bt/foo/bar.mkv"], {dir: "#{$spec_data}/download/foo"})
     d.add("foo/bar.mkv")
    end
  end
end
