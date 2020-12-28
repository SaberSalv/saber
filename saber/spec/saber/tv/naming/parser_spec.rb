require "spec_helper"

Parser = Saber::Tv::Naming::Parser

public_all_methods Parser

describe Parser do
  describe "" do
    it "Prison.Break.S01E04.Hero.Complex.480p.WEB-DL.x264-mSD.mkv" do
      name, season, episode = Parser.new.parse("Prison.Break.S01E04.Hero.Complex.480p.WEB-DL.x264-mSD.mkv")

      expect(name).to eq("Prison Break")
      expect(season).to eq("01")
      expect(episode).to eq("04")
    end

    it "prison.break.s01e04.hero.complex.480p.web-dl.x264-msd.mkv" do
      name, season, episode = Parser.new.parse("prison.break.s01e04.hero.complex.480p.web-dl.x264-msd.mkv")

      expect(name).to eq("Prison Break")
      expect(season).to eq("01")
      expect(episode).to eq("04")
    end

    it "Prison.Break.S02.720p.BluRay.DD5.1.x264-NTb" do
      name, season, episode = Parser.new.parse("Prison.Break.S02.720p.BluRay.DD5.1.x264-NTb")

      expect(name).to eq("Prison Break")
      expect(season).to eq("02")
      expect(episode).to be_nil
    end

    it "Revolution.2012.S01E06.576p.HDTV.x264-DGN.mkv" do
      name, season, episode = Parser.new.parse("Revolution.2012.S01E06.576p.HDTV.x264-DGN.mkv")

      expect(name).to eq("Revolution")
      expect(season).to eq("01")
      expect(episode).to eq("06")
    end

    xit "Conan.2012.11.06.Mindy.Kaling.720p.HDTV.x264-BAJSKORV" do
    end

    it "arrow.105.hdtv-lol.mp4" do
      name, season, episode = Parser.new.parse("arrow.105.hdtv-lol.mp4")

      expect(name).to eq("Arrow")
      expect(season).to eq("01")
      expect(episode).to eq("05")
    end

    it "[HorribleSubs] Hunter X Hunter - 53 [720p].mkv" do
      name, season, episode = Parser.new.parse("[HorribleSubs] Hunter X Hunter - 53 [720p].mkv")

      expect(name).to eq("Hunter X Hunter")
      expect(season).to be_nil
      expect(episode).to eq("53")
    end

    it "merlin_2008.5x08.the_hollow_queen.hdtv_x264-fov.mp4" do
      name, season, episode = Parser.new.parse("merlin_2008.5x08.the_hollow_queen.hdtv_x264-fov.mp4")

      expect(name).to eq("Merlin")
      expect(season).to eq("05")
      expect(episode).to eq("08")
    end
  end
end

