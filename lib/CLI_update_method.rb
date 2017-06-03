require 'date'

module Update

  def update_entry
    filter_and_display_by_borough_and_date

    find_by_CLI_index do |entry, index|
      ask_yes_no("Do you want to update the borough?(y/n)") do
        entry.update(borough: get_new("borough"))
        puts "The borough was successfully updated".colorize(:green)
      end

      ask_yes_no("Do you want to update the incident type?(y/n)") do
        entry.update(incidenttype: get_new("incidenttype"))
        puts "The incident type was successfully updated".colorize(:green)
      end

      ask_yes_no("Do you want to update the description?(y/n)") do
        entry.update(description: get_new("description"))
        puts "The description was successfully updated".colorize(:green)
      end
    end
  end
  
end
