# frozen_string_literal: true

months = %w[January Fedruray March April May June July August September October November
            December]

max_temp_hash = {}
max_temp_hash = { date: '', max_temperature: 0 }

min_temp_hash = {}
min_temp_hash = { date: '', min_temperature: 100 }

max_humidity_hash = {}
max_humidity_hash = { date: '', max_humidity: 0 }

if ARGV[0] == '-e'
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

end
