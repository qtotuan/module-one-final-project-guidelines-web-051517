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
        filter_by_borough(input)
      when "4"
        display_by_year_month
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
    puts ""
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

  # def display_by_year_month
  #   (2012..2017).to_a.each do |year|
  #     # binding.pry
  #     count = Incidenttype_Borough.all_dates.where("open_date > 2012 AND open_date < 2015").count
  #     puts "#{year} (#{count})"
  #   end
  # end

end
