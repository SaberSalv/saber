require "blather/client/dsl"
require "drb"

module Saber
  module AutoFetcher
    class Client
      class << self
        def start
          c = Client.new
          c.start

          EM.run { c.run }
        end
      end

      include Blather::DSL

      attr_reader :fetcher

      def initialize
        @fetcher = Fetcher.new
      end

      def run
        client.run
      end

      def start
        rc = Rc.client.xmpp
        setup rc.jid, rc.password, rc.host, rc.port
        when_ready { Saber.ui.say ">> Connected to xmpp at #{jid}" }
        disconnected { client.connect }

        message :chat?, :body, :from => /#{Rc.server.xmpp.jid}/ do |m|
          process_msg m.body
        end
      end

      def stop
        @client.close!
      end

    protected

      def process_msg(body)
        files = body.split("\n")
        Saber.ui.debug files.map{|v| "RECV #{v}"}.join("\n")
        fetcher.add *files
      end
    end

    class DRbClient
      attr_reader :server

      def initialize
        DRb.start_service
        @server = DRbObject.new_with_uri(Rc.drb_uri)
        Saber.ui.debug ">> DRbClient connected to #{Rc.drb_uri}"
      end

      def add(*names)
        Saber.ui.debug "DRbClient-ADD #{names.inspect}"
        server.add(*names)
      end
    end
  end
end

# vim: fdn=4
