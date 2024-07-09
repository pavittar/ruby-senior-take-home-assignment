require 'redis'

module Vandelay
  module Util
    class Cache
      HOST = Vandelay.config.dig('redis', 'host')
      PORT = Vandelay.config.dig('redis', 'port')
      TTL_SECONDS = 10 * 60

      def initialize
        @store = Redis.new(host: HOST, port: PORT)
      end

      def fetch(key, &block)
        return get(key) if exists?(key)

        result = yield
        set(key, result, TTL_SECONDS)

        result
      end

      def get(key)
        JSON.parse(@store.get(key))
      end

      def set(key, value, ttl = TTL_SECONDS)
        @store.set(key, JSON.dump(value))
        @store.expire(key, ttl)
      end

      def exists?(key)
        !@store.exists(key).zero?
      end

      def flush!
        @store.FLUSHALL
      end
    end
  end
end
