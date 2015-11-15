require 'nokogiri'

module Parsers
  class ArticlePage < Struct.new(:page_content)
    def analyze
      parsed_content
    end

    private
    def parsed_content
      @parsed_content ||= {
        extended_content: current_page.css('.article__content').text,
        comments: fetch_comments
      }
    end

    def fetch_comments
      comments = []
      current_page.css("div[id^='comment']")[1..-1].each do |comment|
        comments << {
          rank: comment.css("span[id^='karma-']").text.to_i,
          content: comment.css(".comment__content").text
        }
      end
      comments
    end

    def current_page
      @current_page ||= Nokogiri::HTML(page_content)
    end
  end
end
