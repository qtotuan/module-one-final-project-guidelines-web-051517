require_relative 'CLI'
require_relative 'CLI_delete_methods'
require "pry"


module Read
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
        incidents = Incidenttype_Borough.where(borough: b).group(:open_date).convert_date_to_days.flatten
        display_results(incidents)
        break
      else
        puts "\nSorry, that's not a valid entry, please select a borough from the listed boroughs.\n".colorize(:red)
      end # end if
    end # end loop
  end # end method

  def display_borough_names
    Borough.all.each do |borough|
      puts "\t#{borough.name}"
    end
  end

  def filter_by_date_range
    loop do
      puts "Please choose a date range between 01/2011 and 06/2017.".colorize(:light_blue)

      to = nil

      puts "\nfrom: mm/yyyy"
      from = gets.chomp
      exit_return_menu(from)
      next if from == "menu"
      if from == "menu"
        filter_by_date_range
      end
      if check_validity(from)
        filter_by_date_range
      end

      loop do
        puts "\nto: mm/yyyy"
        to = gets.chomp
        exit_return_menu(to)
        next if to == "menu"
        # byebug
        if !check_validity(to)
          break
        end
      end

      from_date = Date.new(from.split("/")[1].to_i, from.split("/")[0].to_i, 1)
      to_date = Date.new(to.split("/")[1].to_i, to.split("/")[0].to_i, -1)


      incidents = Incidenttype_Borough.order(:open_date).convert_date_to_days.flatten

      if from_date > to_date
        puts "\nThe information you've entered is invalid, please enter a valid date range.\n".colorize(:red)
      else
        incidents.each do |incident|
          if incident.open_date >= from_date && incident.open_date <= to_date
            puts "#{incident.open_date} - #{incident.borough.name} - #{incident.incidenttype.name}: #{incident.description}"
          end
        end # end each
        break
      end # end if
    end # end loop
  end

  def filter_incidenttype
    loop do
      puts "\nWhich type of incident would you like to view?\n".colorize(:light_blue)
      display_incident_types

      i = gets.chomp
      exit_return_menu(i)
      next if i == "menu"

      i = i.split(" ").map{|w| w.capitalize}.join(" ")


      if Incidenttype.find_by_name(i)
        inc = Incidenttype.find_by_name(i)
        incidents = Incidenttype_Borough.where(incidenttype: inc).order(:open_date).convert_date_to_days.flatten
        puts "#{inc}".colorize(:green)
        incidents.each {|i| puts "#{i.open_date} - #{i.description} - #{i.borough.name}"}
        break
      else
        puts "\nSorry, that's not a valid entry, please select a borough from the listed boroughs.\n".colorize(:red)
      end
    end
  end

  def display_incident_types
    Incidenttype.all.each{|i| puts "\t#{i.name}"}
  end

  def check_validity(input)
    if input.split("/")[0].to_i <= 0 || input.split("/")[0].to_i > 12 || input.split("/")[1].to_i <= 0 || input.split("/")[1].to_i < 2011 || input.split("/")[1].to_i > 2017
      puts "\nThe information you've entered is invalid, please enter a valid date range.\n".colorize(:red)
      true
    end
  end

  def display_by_borough
    puts "\nThese are the incidents recorded by borough:\n".colorize(:light_blue)
    Borough.all.each do |borough|
      puts "\n#{borough.name}".colorize(:yellow)
      Incidenttype.all.each do |type|
        count = Incidenttype_Borough.where(incidenttype: type, borough: borough).count
        puts "\t#{type.name} (#{count})"
      end
    end
  end

  def display_by_type
    puts "\nThese are the incident types recorded and the total number (2011 - present):\n".colorize(:light_blue)
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

  def find_borough_by_name(input)
    input = input.split(" ").map{|char| char.capitalize}.join(" ")
    Borough.find_by_name(borough)
  end

  def long_filter
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
          incidents = date_range_borough(borough)
          break
        elsif input == "n"
          break
        else
          puts "\nSorry, that's not a valid entry, please enter 'y' or 'n'.\n".colorize(:red)
        end
      end # end loop
    end # end if
    display_results(incidents)
  end # end method

  def display_results(arr)
    arr.sort_by{|i| i.open_date}.each_with_index do |row, index|
      puts "\##{index + 1}: #{row.open_date.to_date} - #{row.incidenttype.name} - #{row.borough.name} - #{row.description}"
    end
  end

  def date_range_borough(borough)
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

end
