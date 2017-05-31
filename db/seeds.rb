# Parse the CSV and seed the database here! Run 'ruby db/seed' to execute this code.
require 'csv'
require_relative '../config/environment'
require 'date'
#
csv_array = CSV.read("incidents.csv")
# csv_array.each do |row_array|
#   Borough.create(name: row_array[2])
# end

# csv_array.each do |row_array|
#   Incidenttype.create(name: row_array[0])
# end

def parse_date(string)
  year = string.split(" ")[0].split("/")[2].to_i
  month = string.split(" ")[0].split("/")[0].to_i
  day = string.split(" ")[0].split("/")[1].to_i
  date = DateTime.new(year, month, day)
end

csv_array.each do |row_array|
  borough = Borough.find_by_name(row_array[2])
  incidenttype = Incidenttype.find_by_name(row_array[0])
  Incidenttype_Borough.create(borough: borough, incidenttype: incidenttype, open_date: parse_date(row_array[3]), close_date: parse_date(row_array[4]))
end
