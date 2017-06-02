require 'date'

module Create

  def create_new_entry
    incidenttype = get_incident_type
    description = get_description
    borough = get_borough

    incident = Incidenttype_Borough.create(borough: borough, incidenttype: incidenttype, description: description, open_date: Date.today)

    puts "Your entry was successfully created.".colorize(:green) if incident
  end

  def get_incident_type
    loop do
      puts "Please enter incident type:"
      display_incident_types
      input = gets.chomp
      exit_return_menu(input)
      next if input == "menu"

      input = input.split(" ").map{|w| w.capitalize}.join(" ")
      incident = Incidenttype.find_by_name(input)

      if incident
        return incident
      else
        puts "\nSorry, that's not a valid entry, please select an incident from the list above.\n".colorize(:red)
      end
    end # end loop
  end

  def get_description
    loop do
      puts "Please enter a short description:"
      input = gets.chomp
      exit_return_menu(input)
      next if input == "menu"

      if input.length > 0
        return input
      else
        puts "\nThis field cannot be empty.\n".colorize(:red)
      end
    end # end loop
  end

  def get_borough
    loop do
      puts "Please enter a borough from the list below:\n".colorize(:light_blue)
      display_borough_names
      input = gets.chomp
      exit_return_menu(input)
      next if input == "menu"

      input = input.split(" ").map{|char| char.capitalize}.join(" ")
      borough = Borough.find_by_name(input)

      if borough
        return borough
      else
        puts "\nSorry, that's not a valid entry, please select a borough from the listed boroughs.\n".colorize(:red)
      end # end if
    end # end loop
  end

end
