["crawlers", "entities", "parsers", "persistance"].each do |dir|
  Dir[File.dirname(__FILE__) + "/../#{dir}/*.rb"].each do |file|
    puts "#{__FILE__} Require #{file}"
    require file
  end
end

require './app/controllers/application_controller'

run Sinatra::Application
