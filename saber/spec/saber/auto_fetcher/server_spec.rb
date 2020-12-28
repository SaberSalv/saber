require "spec_helper"

Server = Saber::AutoFetcher::Server
DRbServer = Saber::AutoFetcher::DRbServer
public_all_methods DRbServer

xdescribe DRbServer do
  describe "#build_files" do
    it "works" do
      s = DRbServer.new(nil)
      s.build_files("prison.break", "terra.nova.mkv").sort.should == %w[prison.break/01.prison.break.mkv prison.break/02.prison.break.mkv terra.nova.mkv]
    end
  end
end
