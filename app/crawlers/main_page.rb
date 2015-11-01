require_relative './base_crawler'

module Crawlers
  class MainPage < BaseCrawler
    attr_reader :page

    def initialize(page)
      @page = page
    end

    def persistance_klass
      Persistance::MainPage
    end

    def persistance_key
      page
    end

    def current_page
      @current_page ||= HTTParty.get("http://www.fly4free.pl/page/#{page}").body
    end
  end
end
