require 'httparty'

module Crawlers
  class BaseCrawler
    def fetch
      if persistance_klass.exists(persistance_key)
        persistance_klass.fetch(persistance_key)
      else
        persistance_klass.store(persistance_key, current_page)
        current_page
      end
    end

    def persistance_klass
      raise "Not implemented"
    end

    def persistance_key
      raise "Not implemented"
    end

    def current_page
      raise "Not implemented"
    end
  end
end
