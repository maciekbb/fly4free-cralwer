require_relative './base_crawler'

module Crawlers
  class TagsPage < BaseCrawler
    attr_reader :page, :tag

    def initialize(tag, page)
      @page = page
      @tag = tag
    end

    def persistance_klass
      Persistance::TagsPage
    end

    def persistance_key
      "#{tag}:#{page}"
    end

    def current_page
      @current_page ||= HTTParty.get("http://www.fly4free.pl/tag/#{tag}/page/#{page}").body
    end
  end
end
