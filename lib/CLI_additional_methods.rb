require "pry"

def filter_by_borough
  puts "Which borough would you like to view?"
  borough = gets.chomp
  b = Borough.find_by_name(borough)
  incidents = Incidenttype_Borough.where(borough: b)
  # binding.pry
  incidents.each {|i| puts "#{i.incidenttype.name} - #{i.open_date}"}
end

# def filter_by_date_range
#   puts "from: mm/yyyy"
#   from_date = gets.chomp
#   puts "to: mm/yyyy"
#   from_date = gets.chomp
#
#
# end
