require 'nokogiri'

module Parsers
  class ArticlePage < Struct.new(:page_content)
    def analyze
      Entities::ArticlePage.new(parse_content)
    end

    private
    def parse_content
      @parsed_content ||= {
        extended_content: current_page.css('.article__content').text
      }
    end

    def current_page
      @current_page ||= Nokogiri::HTML(page_content)
    end
  end
end
