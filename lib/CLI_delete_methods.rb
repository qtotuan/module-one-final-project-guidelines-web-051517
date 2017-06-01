require_relative 'CLI_read_methods'
require_relative 'CLI'
require "pry"

module Delete
  def delete_entry
    incidents = nil

    loop do
      puts "Please choose a borough to view all entries\n".colorize(:light_blue)
      display_borough_names
      input = gets.chomp
      exit_return_menu(input)
      next if input == "menu"

      borough = input.split(" ").map{|char| char.capitalize}.join(" ")

      if Borough.find_by_name(borough)
        b = Borough.find_by_name(borough)
        incidents = Incidenttype_Borough.where(borough: b)
        incidents.each_with_index {|entry, index| puts "\##{index + 1}: #{entry.incidenttype.name} - #{entry.open_date}"}
        break
      else
        puts "\nSorry, that's not a valid entry, please select a borough from the listed boroughs.\n".colorize(:red)
      end
    end

    if incidents.length > 15
      loop do
        puts "Do you want to filter your results by date range? (y/n)\n".colorize(:light_blue)
        input = gets.chomp.downcase
        exit_return_menu(input)
        next if input == "menu"

        if input == "y"
          filter_by_date_range
          break
        elsif input == "n"
          break
        else
          puts "\nSorry, that's not a valid entry, please enter 'y' or 'n'.\n".colorize(:red)
        end
      end
    end

    loop do
      puts "Please type the ID\# to delete entry\n".colorize(:light_blue)
      input = gets.chomp
      exit_return_menu(input)
      next if input == "menu"

      index = input.to_i - 1
      entry = incidents[index]

      if entry
        entry.destroy
        puts "Entry \##{input} was successfully deleted from the database.".colorize(:green)
        break
      else
        puts "\nID\# not found. Please choose ID\# from the list above\n".colorize(:red)
      end
    end

  end
end
