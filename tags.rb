require_relative './config/initializers/redis'
require 'pry'

["crawlers", "entities", "parsers", "persistance"].each do |dir|
  Dir[File.dirname(__FILE__) + "/app/#{dir}/*.rb"].each do |file|
    puts "#{__FILE__} Require #{file}"
    require file
  end
end

months = [nil, 'stycznia', 'lutego', 'marca', 'kwietnia', 'maja', 'czerwca',
           'lipca', 'sierpnia', 'września', 'października', 'listopada',
           'grudnia']

tags = ["Berlin", "Barcelona", "Rzym", "Budapeszt", "Bergamo", "Porto",
  "Londyn", "Bolonia", "Ateny", "Lizbona", "Malta", "Bangkok", "Praga",
  "Wilno", "Madryt", "Paryz", "Mediolan", "Dubaj", "Wenecja", "Larnaka"]

distributions = {}
tags.map { |e| e.downcase }.each do |tag|
  current_entries = []
  page = 1
  while true
    page_content = Crawlers::TagsPage.new(tag, page).fetch
    entries = Parsers::TagsPage.new(page_content).analyze
    break if entries.size == 0
    current_entries += entries
    puts "Fetched page #{page} of tag #{tag}"
    page += 1
    # sleep 0.5
  end
  # analyze entries

  distribution = current_entries.flat_map do |entry|
    entry[:date].match(/\d+ (\S+) \d+/).captures.first
  end.group_by do |a|
    a
  end.map do |k, v|
    [k, v.count]
  end.sort_by do |e|
    months.index(e[0])
  end

  distributions[tag] = distribution
end

# end of fetching data
def calculate_distance(vals1, vals2)
  vals1_sum = vals1.inject(:+)
  vals2_sum = vals2.inject(:+)

  (0..11).map { |i| ((vals1[i].to_f/vals1_sum)-(vals2[i].to_f/vals2_sum))**2 }.inject(:+)
end

def calculate_average(distributions)
  if distributions.size > 0
    (0..11).map do |i|
      distributions.map { |d| d[i] }.inject(:+)/distributions.size
    end
  else
    nil
  end
end

def create_cluster(i, stats)
  s = stats.sample
  { name: "#{s[:name]}_cluster", distribution: s[:distribution].clone }
end

clusters = (1..4).map { |i| create_cluster(i, distributions.map { |tag, dist| { name: tag, distribution: dist.map { |d| d[1] } } }) }

iterations = 15

cluster_assigment = {}
iterations.times do |i|
  # assign clusters
  changed = false
  distributions.each do |tag, stat|
    closest_cluster = nil
    closest_cluster_distance = 10000

    clusters.each do |cluster|
      distance = calculate_distance(stat.map { |e| e[1] }, cluster[:distribution])
      if distance < closest_cluster_distance
        cluster_assigment[tag] = cluster[:name]
        closest_cluster_distance = distance
      end
    end

  end

  # update clusters
  clusters.each do |cluster|
    assigned = cluster_assigment.select { |_, cluster_name| cluster[:name] == cluster_name }.keys
    selected_distributions = distributions.select { |tag, _| assigned.include? tag }.map { |_, dist| dist.map { |e| e[1]} }
    average = calculate_average(selected_distributions)
    if average
      if cluster[:distribution] != average
        puts "Changing distribution for #{cluster[:name]}"
        puts "From"
        puts cluster[:distribution].join(", ")
        puts 'to'
        puts average.join(", ")
        changed = true
      end
      cluster[:distribution] = average
    end
  end

  puts "After #{i} iteration"
  puts "Clusters"
  puts clusters
  puts "Cluster assigment"
  clusters.each do |cluster|
    puts " Cluster: #{cluster[:name]}"
    assigned = cluster_assigment.select { |_, cluster_name| cluster[:name] == cluster_name }.keys
    puts assigned
    puts "---"
  end

  break unless changed
end


# distances = {}
# distributions.each do |tag1, stat1|
#   distributions.each do |tag2, stat2|
#     vals1 = stat1.map { |e| e[1] }
#     vals2 = stat2.map { |e| e[1] }
#     begin
#       distances[[tag1, tag2].sort.join("-")] ||= (0..11).map { |i| ((vals1[i].to_f/vals1.inject(:+))-(vals2[i].to_f/vals2.inject(:+)))**2 }.inject(:+)
#     rescue
#       puts "[ERROR] #{tag1} #{vals1.size} and #{tag2} #{vals2.size}"
#     end
#   end
# end
# puts distances.sort_by { |k, v| v }.map { |e| e.join(";")}.join("\n")
