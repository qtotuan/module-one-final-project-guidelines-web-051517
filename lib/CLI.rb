require_relative 'CLI_read_methods'
require_relative 'CLI_delete_methods'
# require "pry"
# require 'artii'
# require 'date'

class CLI
  attr_accessor :incidents, :borough

  include Delete
  include Read
  include Create
  include Update
  include Helpers
  include Filters

  def initialize(incidents = nil, borough = nil)
    @incidents = incidents
    @borough = borough
  end

  def start
    a = Artii::Base.new :font => 'slant'
    puts a.asciify("NYC").colorize(:yellow)
    puts "Welcome to NYC Incident Database".upcase.colorize(:yellow)
    run_main_menu
  end

  def run_main_menu
    loop do
      puts "\nWhat would you like to do?".colorize(:light_blue)
      prompt_menu
      input = gets.chomp
      case input
      when "1"
        display_all_by_borough
      when "2"
        display_all_by_incidenttype
      when "3"
        display_all_by_year_and_quarter
      when "4"
        filter_and_display_by_borough_and_date
      when "5"
        filter_and_display_by_date_range
      when "6"
        filter_and_display_by(Incidenttype)
      when "7"
        create_new_entry
      when "8"
        update_entry
      when "9"
        delete_entry        
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
    puts "[4] Custom filter for borough"
    puts "[5] Custom filter for date range"
    puts "[6] Custom filter for incident type"
    puts "[7] Create a new entry"
    puts "[8] Update an entry"
    puts "[9] Delete an entry"
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
