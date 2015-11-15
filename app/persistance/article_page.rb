require_relative './base_repository'

module Persistance
  class ArticlePage < BaseRepository
    class << self
      def rkey(id)
        "fly4free:article:#{id}"
      end

      def should_expire?
        true
      end

      def expire_in
        60*60*24
      end
    end
  end
end
