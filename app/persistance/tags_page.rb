require_relative './base_repository'

module Persistance
  class TagsPage < BaseRepository
    class << self
      def rkey(id)
        "fly4free:tags:#{id}"
      end

      def should_expire?
        true
      end

      def expire_in
        3*60*60
      end
    end
  end
end
