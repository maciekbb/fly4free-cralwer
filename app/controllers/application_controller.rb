require 'sinatra'

get '/crawl/:page' do
  page_content = Crawlers::MainPage.new(params[:page]).fetch
  Parsers::MainPage.new(page_content).analyze.to_json
end

get '/crawl/article/:id' do
  article_content = Crawlers::ArticlePage.new(id).fetch
  Parsers::ArticlePage.new(article_content).analyze.to_json
end
