module Persistance
  class BaseRepository
    class << self
      def exists(id)
        $redis.exists(rkey(id))
      end

      def store(id, content)
        begin
          $redis.set(rkey(id), content)
          if should_expire?
            $redis.expireat(rkey(id), (Time.now + expire_in).to_i)
          end
        rescue
          puts "Redis error"
        end
      end

      def fetch(id)
        $redis.get(rkey(id))
      end

      def should_expire?
        raise "Not implemented"
      end

      def expire_in
        raise "Not implemented"
      end

      def rkey(id)
        raise "Not implemented"
      end
    end
  end
end
