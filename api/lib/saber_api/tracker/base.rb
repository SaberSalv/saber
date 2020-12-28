require "active_support/core_ext/string/inflections"

class SaberAPI
  class Tracker 
    class Base
      def self.inherited(child)
        Tracker.trackers[child.name.demodulize.underscore] = child
      end

      # delegate to #filter
      def self.filter(*args)
        new.filter(*args)
      end

      # Implement
      def filter(ret, default_backend, data)
        raise NotImplementedError
      end
    end
  end
end
