require_relative './base_repository'

module Persistance
  class ArticlePage < BaseRepository
    class << self
      def rkey(id)
        "fly4free:article:#{id}"
      end
    end
  end
end
