# frozen_string_literal: true

months = %w[Jan Fed Mar Apr May Jun Jul Aug Sep Oct Nov Dec]

max_temp_hash = { date: '', max_temperature: 0 }
min_temp_hash = { date: '', min_temperature: 100 }
max_humidity_hash = { date: '', max_humidity: 0 }

case ARGV[0]
when '-e'
  Dir.foreach(ARGV[2]) do |filename|
    if filename.split('_')[2] == ARGV[1]
      File.open("#{ARGV[2]}/#{filename}") do |line|
        line.seek(391)
        line.readlines.each do |l|
          date = l.split(',')[0]
          max_temperature = l.split(',')[1].to_i
          min_temperature = l.split(',')[3].to_i
          max_humidity = l.split(',')[7].to_i

          if max_temperature >= max_temp_hash[:max_temperature]
            max_temp_hash = { date: date, max_temperature: max_temperature }
          end

          if min_temperature != 0 && min_temperature <= min_temp_hash[:min_temperature]
            min_temp_hash = { date: date, min_temperature: min_temperature }
          end

          if max_humidity >= max_humidity_hash[:max_humidity]
            max_humidity_hash = { date: date, max_humidity: max_humidity }
          end
        end
      end
    end
  end
  max_temp_month = max_temp_hash[:date].split('-')[1].to_i - 1
  max_temp_date = max_temp_hash[:date].split('-')[2].to_i

  min_temp_month = min_temp_hash[:date].split('-')[1].to_i - 1
  min_temp_date = min_temp_hash[:date].split('-')[2].to_i

  max_humidity_month = max_humidity_hash[:date].split('-')[1].to_i - 1
  max_humidity_date = max_humidity_hash[:date].split('-')[2].to_i

  puts "Highest: #{max_temp_hash[:max_temperature]}C on #{months[max_temp_month]} #{max_temp_date}"
  puts "Lowest: #{min_temp_hash[:min_temperature]}C on #{months[min_temp_month]} #{min_temp_date}"
  puts "Humid: #{max_humidity_hash[:max_humidity]}% on #{months[max_humidity_month]} #{max_humidity_date}"

when '-a'
  highest_avg = []
  lowest_avg = []
  avg_humidity = []

  year = ARGV[1].split('/')[0]
  month = months[ARGV[1].split('/')[1].to_i - 1]

  Dir.open(ARGV[2]) do |_filename|
    puts "Filename: #{ARGV[2]}/#{ARGV[2]}_#{year}_#{month}.txt"
    File.open("#{ARGV[2]}/#{ARGV[2]}_#{year}_#{month}.txt") do |line|
      line.seek(390)
      line.readlines.each do |l|
        highest_avg.push(l.split(',')[1].to_i)
        lowest_avg.push(l.split(',')[3].to_i)
        avg_humidity.push(l.split(',')[7].to_i)
      end
    end
  end

  puts
  puts "Highest Avgerage: #{(highest_avg.sum(0.0) / highest_avg.size).round(1)}C"
  puts "Lowest Avgerage: #{(lowest_avg.sum(0.0) / lowest_avg.size).round(1)}C"
  puts "Average Humidity: #{(avg_humidity.sum(0.0) / avg_humidity.size).round(1)}%"
end
