require_relative 'CLI_read_methods'
require "pry"

class CLI

  def start
    puts "\nWelcome to NYC Incident Database".upcase.colorize(:yellow)
    run_main_menu
  end

  def run_main_menu
    loop do
      puts "\nWhat would you like to do?".colorize(:light_blue)
      prompt_menu
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
      when "5"
        filter_by_date_range
      when "return"
        run_main_menu
      when "menu"
        prompt_menu
      when "exit"
        exit(0)
      else
        puts "\nCommand not found. Please choose from the menu options.".colorize(:red)
      end
    end
  end

  def prompt_menu
    puts ""
    puts "-------------"
    puts "*** MENU ***"
    puts "[1] Display incidents by borough"
    puts "[2] Display by incident type"
    puts "[3] Display by year and quarter"
    puts "[4] Display for selected borough"
    puts ""
    puts "Type 'return' anytime to return to the main menu"
    puts "Type 'menu' anytime to display the menu options"
    puts "Type 'exit' anytime to quit the program"
    puts "-------------"
  end

  def exit_return_menu(input)
    case input
    when "return"
      run_main_menu
    when "menu"
      prompt_menu
    when "exit"
      exit(0)
    end
  end

end
