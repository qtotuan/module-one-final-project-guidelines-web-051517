require_relative 'CLI_additional_methods'
require "pry"

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
    puts "[3] Display by year and quarter"
    puts "[4] Display for selected borough"
    puts "Type 'exit' to quit the program"
  end

  

end
