module Persistance
  class BaseRepository
    class << self
      def exists(id)
        $redis.exists(rkey(id))
      end

      def store(id, content)
        $redis.set(rkey(id), content)
        $redis.expireat(rkey(id), (Time.now + 10*60).to_i)
      end

      def fetch(id)
        $redis.get(rkey(id))
      end

      def rkey(id)
        raise "Not implemented"
      end
    end
  end
end
