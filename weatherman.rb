# frozen_string_literal: true

require 'colorize'

months = %w[Jan Fed Mar Apr May Jun Jul Aug Sep Oct Nov Dec]

case ARGV[0]
when '-e'
  max_temp_hash = {}
  min_temp_hash = {}
  max_humidity_hash = {}

  Dir.foreach(ARGV[2]) do |filename|
    if filename.split('_')[2] == ARGV[1]
      File.open("#{ARGV[2]}/#{filename}") do |line|
        line.seek(391)
        line.readlines.each do |l|
          date = l.split(',')[0]
          max_temperature = l.split(',')[1].to_i
          min_temperature = l.split(',')[3].to_i
          max_humidity = l.split(',')[7].to_i

          if max_temp_hash[:max_temperature].nil?
            max_temp_hash = { date: date, max_temperature: max_temperature }
            min_temp_hash = { date: date, min_temperature: min_temperature }
            max_humidity_hash = { date: date, max_humidity: max_humidity }
          end

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
  if max_temp_hash[:max_temperature]

    max_temp_month = max_temp_hash[:date].split('-')[1].to_i - 1
    max_temp_date = max_temp_hash[:date].split('-')[2].to_i

    min_temp_month = min_temp_hash[:date].split('-')[1].to_i - 1
    min_temp_date = min_temp_hash[:date].split('-')[2].to_i

    max_humidity_month = max_humidity_hash[:date].split('-')[1].to_i - 1
    max_humidity_date = max_humidity_hash[:date].split('-')[2].to_i

    puts "Highest: #{max_temp_hash[:max_temperature]}C on #{months[max_temp_month]} #{max_temp_date}"
    puts "Lowest: #{min_temp_hash[:min_temperature]}C on #{months[min_temp_month]} #{min_temp_date}"
    puts "Humid: #{max_humidity_hash[:max_humidity]}% on #{months[max_humidity_month]} #{max_humidity_date}"
  else
    puts 'Oopps! No record found for this year.'
  end

when '-a'
  highest_avg = []
  lowest_avg = []
  avg_humidity = []

  year = ARGV[1].split('/')[0]
  month = months[ARGV[1].split('/')[1].to_i - 1]

  Dir.open(ARGV[2]) do |_filename|
    File.open("#{ARGV[2]}/#{ARGV[2]}_#{year}_#{month}.txt") do |line|
      line.seek(390)
      line.readlines.each do |l|
        highest_avg.push(l.split(',')[1].to_i)
        lowest_avg.push(l.split(',')[3].to_i)
        avg_humidity.push(l.split(',')[7].to_i)
      end
    end
  end

  puts "Highest Avgerage: #{(highest_avg.sum(0.0) / highest_avg.size).round(1)}C"
  puts "Lowest Avgerage: #{(lowest_avg.sum(0.0) / lowest_avg.size).round(1)}C"
  puts "Average Humidity: #{(avg_humidity.sum(0.0) / avg_humidity.size).round(1)}%"

when '-c'
  temperatures = []

  year = ARGV[1].split('/')[0]
  month = months[ARGV[1].split('/')[1].to_i - 1]

  Dir.open(ARGV[2]) do |_filename|
    File.open("#{ARGV[2]}/#{ARGV[2]}_#{year}_#{month}.txt") do |line|
      line.seek(391)
      line.readlines.each do |l|
        temperatures << { highest: l.split(',')[1].to_i, lowest: l.split(',')[3].to_i }
      end
    end
  end

  puts "#{month} #{year}"
  temperatures[0, (temperatures.size - 1)].each_with_index do |temp, i|
    # Simple Task Output

    # print "\n#{i + 1} "
    # print('+'.red * temp[:highest] + " #{temp[:highest]}C")
    # print "\n#{i + 1} "
    # print('+'.blue * temp[:lowest] + " #{temp[:lowest]}C")

    # Bonus Task Output

    print "\n#{i + 1} "
    print('+'.blue * temp[:lowest] + '+'.red * temp[:highest] + " #{temp[:lowest]}C - #{temp[:highest]}C")
  end
  puts "\n"

else
  puts 'Invalid Command!'

end
