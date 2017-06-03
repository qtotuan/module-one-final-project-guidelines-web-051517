module Helpers

  def ask(question)
    loop do
      puts question.colorize(:light_blue)
      input = gets.chomp
      exit_return_menu(input)
      next if input == "menu"
      block_given? ? yield(input) : break
    end
  end

  def ask_yes_no(question)
    ask(question) do |input|
      if input == "y"
        yield
        break
      elsif input == "n"
        break
      else
        puts "\nSorry, that's not a valid entry, please enter 'y' or 'n'.\n".colorize(:red)
      end
    end
  end

  def valid?(input)
    month = input.split("/")[0].to_i
    year = input.split("/")[1].to_i
    (month > 0 && month <= 12) && (year >= 2011 && year <= 2017)
  end

  def get_date(type)
    date = nil

    ask("\n#{type}: mm/yyyy") do |input|
      if valid?(input)
        date = input
        break
      else
        puts "Date is not valid.".colorize(:red)
      end
    end

    if type == "from"
      return Date.new(date.split("/")[1].to_i, date.split("/")[0].to_i, 1)
    elsif type == "to"
      return Date.new(date.split("/")[1].to_i, date.split("/")[0].to_i, -1)
    end
  end

  def display_results_with_index(arr)
    arr.each_with_index do |row, index|
      puts "\##{index + 1}: #{row.open_date.to_date} - #{row.incidenttype.name} - #{row.borough.name} - #{row.description}"
    end
  end

  def parse(input)
    input.split(" ").map{|char| char.capitalize}.join(" ")
  end

  def get_new(attribute)
    attribute = attribute
    ask("Please enter #{attribute}") do |input|
      case attribute
      when "incidenttype"
        result = Incidenttype.find_by_name(parse(input))
      when "borough"
        result = Borough.find_by_name(parse(input))
      when "description"
        result = input
      end

      if result
        return result
      else
        puts "\nSorry, that's not a valid entry, please select from the list.\n".colorize(:red)
        # byebug
        if attribute == "incidenttype"
          Incidenttype.list_names
        elsif attribute == "borough"
          Borough.list_names
        end # end if
      end # end if
    end # end ask
  end # end method

  def find_by_CLI_index
    ask("Please select ID\#\n") do |input|
      index = input.to_i - 1
      if index >= 0
        entry = @incidents[index]
      else
        entry = nil
      end

      if entry
        yield(entry, input)
        break
      else
        puts "\nID\# not found. Please choose ID\# from the list above\n".colorize(:red)
      end
    end
  end

end
