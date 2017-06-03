require_relative 'CLI'
require_relative 'CLI_delete_methods'
require "pry"

module Read

  def filter_and_display_by(klass)
    @incidents = filter_by(klass)
    display_results_with_index(@incidents)
  end

  def filter_and_display_by_date_range
    @incidents = filter_by_date_range
    display_results_with_index(@incidents)
  end

  def filter_and_display_by_borough_and_date
    @borough = nil
    @incidents = filter_by(Borough)
    display_results_with_index(@incidents)

    if @incidents.length > 15
      ask_yes_no("Do you want to filter your results by date range? (y/n)\n") do |input|
        @incidents = filter_by_date_range(@borough)
        display_results_with_index(@incidents)
      end
    end
  end

  def display_all_by_borough
    puts "\nThese are the incidents recorded by borough:\n".colorize(:light_blue)
    Borough.all.each do |borough|
      puts "\n#{borough.name}".colorize(:yellow)
      Incidenttype.all.each do |type|
        count = Incidenttype_Borough.where(incidenttype: type, borough: borough).count
        puts "\t#{type.name} (#{count})"
      end
    end
  end

  def display_all_by_incidenttype
    puts "\nThese are the incident types recorded and the total number (2011 - present):\n".colorize(:light_blue)
    Incidenttype.all.each do |type|
      count = Incidenttype_Borough.where(incidenttype: type).count
      puts "#{type.name} (#{count})"
    end
  end

  def display_all_by_year_and_quarter
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

end
