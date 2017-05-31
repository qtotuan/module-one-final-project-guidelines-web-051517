# Parse the CSV and seed the database here! Run 'ruby db/seed' to execute this code.
require 'csv'
require_relative '../config/environment'
require 'date'
#
csv_array = CSV.read("incidents.csv")

dictionary = {
  "Manhattan" => ["Manhatten", "manhattan", "MANHATTAN", "Mamhattan", "Mnahattan", "Manhatan", "Manhhattan", "Manhaatan", "Manahttan", "Manhttan", "Manhattan (Pier 92)", "Manhattah", "Manhattan (Waldorf Astoria)"],
  "Queens" => ["queens", "QUEENS"],
  "Brooklyn" => ["Brooklyn (NYCHA-Brevoort)"],
  "New York" => ["new york", "Citywide", "NewYork", "nyc"],
  "Staten Island" => ["Staten ISland", "staten island", "Staten island", "Richmond/Staten Island", "Staten Island (Midland Beach Area)", "staten Island", "SI"],
  "Bronx" => ["bronx", "Bronx (NYCHA)", "BrONX"]
}

csv_array.each_with_index do |row_array, index|
  next if index == 0 #ignore first line
  name = row_array[2]
  dictionary.each do | borough_name, name_array |
    name = borough_name if name_array.include?(row_array[2])
  end
  # binding.pry
  Borough.create(name: name)
end

csv_array.each_with_index do |row_array, index|
  next if index == 0 #ignore first line
  name = row_array[0].split("-")[0]
  # binding.pry
end

def parse_date(string)
  return nil if string == nil || string.empty?
  year = string.split(" ")[0].split("/")[2].to_i
  month = string.split(" ")[0].split("/")[0].to_i
  day = string.split(" ")[0].split("/")[1].to_i
  date = Date.new(year, month, day)
end

csv_array.each_with_index do |row_array, index|
  next if index == 0 # ignore headers
  borough = Borough.find_by_name(row_array[2])
  incidenttype = Incidenttype.find_by_name(row_array[0].split("-")[0])
  # binding.pry
  Incidenttype_Borough.create(borough: borough, incidenttype: incidenttype, open_date: parse_date(row_array[3]), close_date: parse_date(row_array[4]))
end
