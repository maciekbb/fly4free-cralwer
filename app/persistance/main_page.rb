require_relative './base_repository'

module Persistance
  class MainPage < BaseRepository
    class << self
      def rkey(id)
        "fly4free:page:#{id}"
      end
    end
  end
end
