require 'pry'
require 'redis'

require_relative 'config/initializers/redis'

["crawlers", "entities", "parsers", "persistance"].each do |dir|
  Dir[File.dirname(__FILE__) + "/app/#{dir}/*.rb"].each do |file|
    require file
  end
end

page_content = Crawlers::MainPage.new(1).fetch

parsed = Parsers::MainPage.new(page_content).analyze
article_content = Crawlers::ArticlePage.from_url(parsed.entries[1][:url]).fetch
parsed_article = Parsers::ArticlePage.new(article_content).analyze
binding.pry
