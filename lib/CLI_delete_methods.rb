require_relative 'CLI_read_methods'
require_relative 'CLI'
require "pry"

module Delete

  def delete_entry
    filter_and_display_by_borough_and_date

    find_by_CLI_index do |entry, input|
      entry.destroy
      puts "Entry \##{input} was successfully deleted from the database.".colorize(:green)
    end
  end

end 
