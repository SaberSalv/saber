require "xmlrpc/client"
require "net/ssh"

module Saber
  class Fetcher

    def add_names(*names)
      files = retrive_files(*names)
      add(*files)
    end

    def aria2_add(uris, o={}, &blk)
      @aria2 = XMLRPC::Client.new2(Rc.aria2.rpc)
      @aria2.call("aria2.addUri", uris, o, &blk)
    end

    def add(*files)
      files.each { |file|
        uri = "#{Rc.server.ftp}/#{file}"
        gid = aria2_add([uri], :dir => Pa.dir2("#{Rc.fetch.dir}/#{file}"))
        Saber.ui.debug "DOWNLOAD #{gid} #{uri}"
      }
    end

  private

    def retrive_files(*names)
      files = []
      Net::SSH.start(Rc.server.host, Rc.server.user) do |s|
        name = "'#{names.join("' '")}'"
        cmd = "cd #{Rc.fetch.remote_dir} && find #{name} -type f"

        rst = s.exec!(cmd)
        if rst =~ /^find: `|^cd:cd:/
          raise Error, rst 
        elsif rst.nil?
          raise Error, "remote `#{name}' is an empty directory."
        end

        files = rst.split("\n")
      end

      files
    end
  end
end
