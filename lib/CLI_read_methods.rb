require "pry"
require_relative 'CLI.rb'

def filter_by_borough
  loop do
    puts "Which borough would you like to view?\n".colorize(:light_blue)
    display_borough_names
    borough = gets.chomp
    exit_return_menu(borough)
    next if borough == "menu"

    borough = borough.split(" ").map{|char| char.capitalize}.join(" ")

    if Borough.find_by_name(borough)
      b = Borough.find_by_name(borough)
      incidents = Incidenttype_Borough.where(borough: b)
      # binding.pry
      incidents.each {|i| puts "#{i.incidenttype.name} - #{i.open_date}"}
      break
    else
      puts "\nSorry, that's not a valid entry, please select a borough from the listed boroughs.\n".colorize(:red)
    end
  end
end

def display_borough_names
  Borough.all.each do |borough|
    puts "#{borough.name}".colorize(:green)
  end
end

def filter_by_date_range
  loop do
    puts "from: mm/yyyy"
    from = gets.chomp
    exit_return_menu(from)
    next if from == "menu"
    if from == "menu"
      filter_by_date_range
    end

    puts "to: mm/yyyy"
    to = gets.chomp
    exit_return_menu(to)
    next if to == "menu"
    invalid = to.split("/")[0].to_i == 0 || from.split("/")[0].to_i == 0 || from.split("/")[1].to_i == 0

    if invalid
      puts "\nThe information you've entered is invalid, please enter a valid date range.\n".colorize(:red)
      filter_by_date_range
    end

    from_date = Date.new(from.split("/")[1].to_i, from.split("/")[0].to_i, 1)
    to_date = Date.new(to.split("/")[1].to_i, to.split("/")[0].to_i, -1)

    incidents = Incidenttype_Borough.group(:open_date).convert_date_to_days.flatten

    if from_date > to_date
      puts "\nThe information you've entered is invalid, please enter a valid date range.\n".colorize(:red)
    else
      incidents.each do |incident|
        if incident.open_date >= from_date && incident.open_date <= to_date
          puts "#{incident.open_date} - #{incident.incidenttype.name} - #{incident.borough.name}"
        end
      end
    end
  end
end

def display_by_borough
  puts "\nThese are the incidents recorded by borough:\n"
  Borough.all.each do |borough|
    puts "\n#{borough.name}".colorize(:yellow)
    Incidenttype.all.each do |type|
      count = Incidenttype_Borough.where(incidenttype: type, borough: borough).count
      # binding.pry
      puts "\t#{type.name} (#{count})"
    end
  end
end

def display_by_type
  puts "\nThese are the incident types recorded and the total number (2011 - present):\n"
  Incidenttype.all.each do |type|
    count = Incidenttype_Borough.where(incidenttype: type).count
    puts "#{type.name} (#{count})"
  end
end

def display_by_year_and_quarter
  (2011..2017).to_a.each do |year|
    entries_with_year = Incidenttype_Borough.convert_date_to_years.flatten
    count_per_year = entries_with_year.count { |entry| entry.open_date == year}

    entries_with_days = Incidenttype_Borough.convert_date_to_days.flatten
    count_q1 = entries_with_days.count { |entry| entry.open_date >= Date.new(year, 1, 1) && entry.open_date <= Date.new(year, 3, 31)}
    count_q2 = entries_with_days.count { |entry| entry.open_date >= Date.new(year, 4, 1) && entry.open_date <= Date.new(year, 6, 30)}
    count_q3 = entries_with_days.count { |entry| entry.open_date >= Date.new(year, 7, 1) && entry.open_date <= Date.new(year, 9, 30)}
    count_q4 = entries_with_days.count { |entry| entry.open_date >= Date.new(year, 10, 1) && entry.open_date <= Date.new(year, 12, 31)}


    puts "#{year}:".colorize(:yellow) + " #{count_per_year} incidents"
    puts "\tQ1: #{count_q1} incidents"
    puts "\tQ2: #{count_q2} incidents"
    puts "\tQ3: #{count_q3} incidents"
    puts "\tQ4: #{count_q4} incidents"
  end
end
