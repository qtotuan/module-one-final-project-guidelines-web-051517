module Update

  def update_entry
    filter_and_display_by_borough_and_date

    find_by_CLI_index do |entry, index|
      ["borough", "incidenttype", "description"].each do |field|
        ask_yes_no("Do you want to update the #{field}?(y/n)") do
          entry.update(field.to_sym => get_new(field))
          puts "The #{field} was successfully updated".colorize(:green)
        end
      end
    end
  end

end
