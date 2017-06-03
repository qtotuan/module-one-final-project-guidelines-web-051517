require 'date'

module Create

  def create_new_entry
    incidenttype = get_new("incidenttype")
    description = get_new("description")
    borough = get_new("borough")

    incident = Incidenttype_Borough.create(borough: borough, incidenttype: incidenttype, description: description, open_date: Date.today)

    puts "Your entry was successfully created.".colorize(:green) if incident
  end

end
