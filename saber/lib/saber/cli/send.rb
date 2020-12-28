module Saber
  class CLI
    desc "send1 <src ..> <dest>", "send files to seedbox"
    # @overload send(*files, dest)
    def send1(*args)
      require "shellwords"
      require "tagen/core/kernel/shell"

      if args.length == 1 then
        Saber.ui.error! "At least one src for send -- src: nil, dest: #{args[1].inspect}."
      end

      *files, dest = args
      system "rsync -ahP #{files.shelljoin} #{Rc.server.user}@#{Rc.server.host}:#{dest}", show_cmd: "$" 
    end
  end
end
