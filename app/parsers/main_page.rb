require 'nokogiri'

module Parsers
  class MainPage < Struct.new(:page_content)
    def analyze
      parsed_entities
    end

    private

    def parsed_entities
      @entries ||= current_page.css('.entry').flat_map do |entry|
        parse_entry(entry)
      end
    end

    def parse_entry(entry)
      if entry.css(".entry__title a").any?
        [{
          url: entry.css(".entry__title a")[0]["href"],
          date: entry.css(".date").text,
          title: entry.css(".entry__title").text,
          content: entry.css(".entry__content").text
        }]
      else
        []
      end
    end

    def current_page
      @current_page ||= Nokogiri::HTML(page_content)
    end
  end
end
