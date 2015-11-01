require 'sinatra'
require 'pry'

["crawlers", "entities", "parsers", "persistance"].each do |dir|
  Dir[File.dirname(__FILE__) + "/../#{dir}/*.rb"].each do |file|
    puts "#{__FILE__} Require #{file}"
    require file
  end
end

get '/crawl/:page' do
  page_content = Crawlers::MainPage.new(params[:page]).fetch
  Parsers::MainPage.new(page_content).analyze.to_json
end

get '/crawl/article/:id' do
  article_content = Crawlers::ArticlePage.new(id).fetch
  Parsers::ArticlePage.new(article_content).analyze.to_json
end
