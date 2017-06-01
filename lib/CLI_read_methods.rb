require "pry"
require_relative 'CLI.rb'

def filter_by_borough
  puts "Which borough would you like to view?"
  borough = gets.chomp

  if Borough.find_by_name(borough)
    b = Borough.find_by_name(borough)
    incidents = Incidenttype_Borough.where(borough: b)
    # binding.pry
    incidents.each {|i| puts "#{i.incidenttype.name} - #{i.open_date}"}
    puts "Sorry, that's not a valid entry, please type "
  elsif borough == "exit" || borough == "return" || borough == "menu"
    
  else
  end

end

# def filter_by_date_range
#   puts "from: mm/yyyy"
#   from_date = gets.chomp
#   puts "to: mm/yyyy"
#   from_date = gets.chomp
#
#
# end

def display_by_borough
  puts "These are the incidents recorded by borough:"
  Borough.all.each do |borough|
    puts borough.name.colorize(:red)
    Incidenttype.all.each do |type|
      count = Incidenttype_Borough.where(incidenttype: type, borough: borough).count
      # binding.pry
      puts type.name.colorize(:magenta) + " (#{count})"
    end
  end
end

def display_by_type
  puts "These are the incident types recorded:"
  Incidenttype.all.each do |type|
    count = Incidenttype_Borough.where(incidenttype: type).count
    puts "#{type.name.colorize(:red)} (#{count})"
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
