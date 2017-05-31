require_relative 'CLI_additional_methods'

class CLI

  def start
    puts "Welcome to NYC Incident Database".colorize(:magenta)
    prompt_menu
    run_main_menu
  end

  def run_main_menu
    loop do
      puts "Please chose from the menu:".colorize(:light_blue)
      input = gets.chomp
      case input
      when "1"
        display_by_borough
      when "2"
        display_by_type
      when "3"
        display_by_year_and_quarter
      when "4"
        filter_by_borough
      when "exit"
        exit(0)
      end
    end
  end

  def prompt_menu
    puts ""
    puts "MENU"
    puts "[1] Display incidents by borough"
    puts "[2] Display by incident type"
    puts "[3] Display by year"
    puts "[4] Display for selected borough"
    puts "Type 'exit' to quit the program"
  end

  def display_by_borough
    Borough.all.each do |borough|
      puts borough.name.colorize(:red)
      Incidenttype.all.each do |type|
        count = Incidenttype_Borough.where(incidenttype: type, borough: borough).count
        # binding.pry
        puts "#{type.name}: (#{count})".colorize(:green)
      end
    end
  end

  def display_by_type
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

end
