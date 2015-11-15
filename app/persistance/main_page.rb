require_relative './base_repository'

module Persistance
  class MainPage < BaseRepository
    class << self
      def rkey(id)
        "fly4free:page:#{id}"
      end

      def should_expire?
        true
      end

      def expire_in
        10*60
      end
    end
  end
end
