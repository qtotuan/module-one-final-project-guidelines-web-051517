require_relative 'CLI_read_methods'
require_relative 'CLI'
require "pry"

module Delete

  def delete_entry
    incidents = nil
    borough = nil

    loop do
      puts "Please choose a borough to view all entries\n".colorize(:light_blue)
      display_borough_names
      input = gets.chomp
      exit_return_menu(input)
      next if input == "menu"

      borough = input.split(" ").map{|char| char.capitalize}.join(" ")

      if Borough.find_by_name(borough)
        borough = Borough.find_by_name(borough)
        incidents = Incidenttype_Borough.where(borough: borough)
        display_results(incidents)
        # incidents.each_with_index {|entry, index| puts "\##{index + 1}: #{entry.incidenttype.name} - #{entry.open_date}"}
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
          incidents = filter_by_date_range_and_borough(borough)
          break
        elsif input == "n"
          break
        else
          puts "\nSorry, that's not a valid entry, please enter 'y' or 'n'.\n".colorize(:red)
        end
      end # end loop
    end # end if

    display_results(incidents)

    loop do
      puts "Please type the ID\# to delete entry\n".colorize(:light_blue)
      input = gets.chomp
      exit_return_menu(input)
      next if input == "menu"

      index = input.to_i - 1
      if index >= 0
        entry = incidents[index]
      else
        entry = nil
      end

      if entry
        entry.destroy
        puts "Entry \##{input} was successfully deleted from the database.".colorize(:green)
        break
      else
        puts "\nID\# not found. Please choose ID\# from the list above\n".colorize(:red)
      end
    end # end loop
  end # end delete entry



  def valid?(input)
    month = input.split("/")[0].to_i
    year = input.split("/")[1].to_i
    (month > 0 && month <= 12) && (year >= 2011 && year <= 2017)
  end

  def get_date(type)
    date = nil
    loop do
      puts "\n#{type}: mm/yyyy"
      input = gets.chomp
      exit_return_menu(input)
      next if input == "menu"

      if valid?(input)
        date = input
        break
      else
        puts "Date is not valid.".colorize(:red)
      end
    end

    if type == "from"
      date = Date.new(date.split("/")[1].to_i, date.split("/")[0].to_i, 1)
    elsif type == "to"
      date = Date.new(date.split("/")[1].to_i, date.split("/")[0].to_i, -1)
    end

    date
  end

  def display_results(arr)
    arr.each_with_index do |row, index|
      puts "\##{index + 1}: #{row.open_date.to_date} - #{row.incidenttype.name} - #{row.borough.name} - #{row.description}"
    end
  end


  def filter_by_date_range_and_borough(borough)
    incidents = []
    from = nil
    to = nil

    loop do
      puts "Please choose a date range between 01/2011 and 06/2017.".colorize(:light_blue)

      from = get_date("from")
      to = get_date("to")

      if from > to
        puts "\nThe end date has to be later than start date. Please enter a valid date range.\n".colorize(:red)
        next
      end

      incidents_with_date = Incidenttype_Borough.convert_date_to_days.flatten

      incidents_with_date.each do |incident|
        incidents << incident if (incident.open_date >= from && incident.open_date <= to && incident.borough == borough)
      end

      if incidents.empty?
        puts "\nThere were no results for this date range. Try a larger range.\n".colorize(:red)
        next
      end

      break
    end # end loop
    incidents
  end # end method

end #module
