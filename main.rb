require 'nokogiri'
require 'open-uri'
require 'yaml'
require 'sinatra'
require 'json'

class Fly4FreePage
  def fetch(page)
    page = Nokogiri::HTML(open("http://www.fly4free.pl/page/#{page}"))
    entries = page.css(".entry")

    entities = entries.flat_map do |entry|
      data = {
        date: entry.css(".date").text,
        title: entry.css(".entry__title").text,
        content: entry.css(".entry__content").text
      }
      if data.values.all? { |v| v.to_s.size > 0 }
        data[:date] = parse_date(data[:date])
        data
      else
        []
      end
    end

    entities
  end

  private

  def parse_date(date)
    match = /(\d+) (\S+) (\d+), (\d+):(\d+)/.match(date)
    if match
      {
        date: date,
        parsed: DateTime.new(match[3].to_i, MONTH_MAP[match[2]], match[1].to_i, match[4].to_i, match[5].to_i).to_s
      }
    else
       raise "invalid date provided - #{date}"
    end
  end

  MONTH_MAP = {
    "października" => 9
  }
end

get '/crawl/:page' do
  page = Fly4FreePage.new
  page.fetch(params[:page]).to_json
end
