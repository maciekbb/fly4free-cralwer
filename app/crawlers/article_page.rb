require_relative './base_crawler'

module Crawlers
  class ArticlePage < BaseCrawler
    attr_reader :article_id

    def initialize(article_id)
      @article_id = article_id
    end

    def self.from_url(url)
      article_id = /http:\/\/www.fly4free.pl\/(.*)\//.match(url).captures[0]
      raise "Invalid url #{url}" unless article_id
      new(article_id)
    end

    def persistance_klass
      Persistance::ArticlePage
    end

    def persistance_key
      article_id
    end

    def current_page
      @current_page ||= HTTParty.get("http://www.fly4free.pl/#{article_id}").body
    end
  end
end
