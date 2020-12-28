require "blather/client/dsl"
require "drb"

module Saber
  module AutoFetcher
    class Server
      include Blather::DSL

      def self.start
        s = Server.new
        DRbServer.start(s)
        s.start

        EM.run { s.run }
      end

      def run
        client.run
      end

      def start
        rc = Rc.server.xmpp
        setup rc.jid, rc.password, rc.host, rc.port

        when_ready { Saber.ui.say ">> Connected to xmpp at #{jid}" }
        disconnected { client.connect }
      end

      def send(files)
        msg = files.join("\n")
        Saber.ui.debug files.map{|v| "SEND #{v}"}.join("\n")
        say Rc.client.xmpp.jid , msg
      end
    end

    class DRbServer
      class << self
        def start(saber_server)
          DRbServer.new(saber_server).start
        end
      end

      attr_reader :saber_server

      # @params [Server] server
      def initialize(saber_server)
        @saber_server = saber_server
      end

      def start
        DRb.start_service Rc.drb_uri, self
        Saber.ui.say ">> DRbSever listening on #{Rc.drb_uri}"
      end

      # drb. add a complete torrent.
      def add(*names)
        files = build_files(*names) 
        saber_server.send(files)
      rescue => e
        Saber.ui.error "#{e.class.name}: #{e.message}"
        Saber.ui.error e.backtrace.join("\n")
      end

    private

      # ["filea", "foo/filea", "foo/fileb"]
      def build_files(*names)
        Pa.ls2_r(*names, :base_dir => Rc.fetch.remote_dir, :file => true, :include => true) { |p,abs| not Pa.directory?(abs) }
      end
    end
  end
end
