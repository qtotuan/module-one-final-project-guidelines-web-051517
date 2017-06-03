module Filters

  def filter_by(klass)
    @incidents = nil

    loop do
      puts "\nWhich #{klass.name} would you like to view?\n".colorize(:light_blue)

      klass.list_names

      input = gets.chomp
      exit_return_menu(input)
      next if input == "menu"

      # byebug
      result = klass.find_by_name(parse(input))
      @borough = result if klass == Borough


      if result
        return @incidents = Incidenttype_Borough.where(borough: result) if klass == Borough
        return @incidents = Incidenttype_Borough.where(incidenttype: result) if klass == Incidenttype
      else
        puts "\nSorry, that's not a valid entry, please select from the list.\n".colorize(:red)
      end
    end
  end


  def filter_by_date_range(borough = nil)
    @incidents = []
    @borough = borough
    from = nil
    to = nil

    loop do
      puts "Please choose a date range between 01/2011 and 06/2017."
      from = get_date("from")
      to = get_date("to")

      if from > to
        puts "\nThe end date has to be later than start date. Please enter a valid date range.\n".colorize(:red)
        next
      end

      incidents_with_date = Incidenttype_Borough.convert_date_to_days.flatten

      # byebug

      incidents_with_date.each do |incident|
        if @borough.nil?
          @incidents << incident if (incident.open_date >= from && incident.open_date <= to)
        else
          @incidents << incident if (incident.open_date >= from && incident.open_date <= to && incident.borough == borough)
        end

      end

      if !@incidents.empty?
        return @incidents
      else
        puts "\nThere were no results for this date range. Try a larger range.\n".colorize(:red)
      end # end if
    end # end loop
  end # end method

end
