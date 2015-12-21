require 'sinatra'
require_relative './config/initializers/redis'

["crawlers", "entities", "parsers", "persistance"].each do |dir|
  Dir[File.dirname(__FILE__) + "/app/#{dir}/*.rb"].each do |file|
    puts "#{__FILE__} Require #{file}"
    require file
  end
end

get '/crawl/:page' do
  page_content = Crawlers::MainPage.new(params[:page]).fetch
  entries = Parsers::MainPage.new(page_content).analyze

  entries.each do |entry|
    article_content = Crawlers::ArticlePage.from_url(entry[:url]).fetch
    parsed_article = Parsers::ArticlePage.new(article_content).analyze
    entry.merge!(parsed_article)
  end

  entries.to_json
end

get '/crawl/tag/:tag/page/:page' do
  page_content = Crawlers::TagsPage.new(params[:tag], params[:page]).fetch
  entries = Parsers::TagsPage.new(page_content).analyze

  entries.to_json
end

get '/crawl/article/:id' do
  article_content = Crawlers::ArticlePage.new(params[:id]).fetch
  Parsers::ArticlePage.new(article_content).analyze.to_json
end
