# frozen_string_literal: true

months = %w[January Fedruray March April May June July August September October November
            December]

if ARGV[0] == '-e'
  Dir.foreach(ARGV[2]) do |filename|
    if filename.split('_')[2] == ARGV[1]
      File.open("#{ARGV[2]}/#{filename}") do |line|
        puts line.read
      end
    end
  end
end
