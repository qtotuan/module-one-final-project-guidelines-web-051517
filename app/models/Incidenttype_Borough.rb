require "pry"

class Incidenttype_Borough < ActiveRecord::Base
  belongs_to :borough
  belongs_to :incidenttype

  def self.convert_date_to_years
    Incidenttype_Borough.all.each do |i|
      i.open_date = i.open_date.to_date.year
      # binding.pry
    end
  end

  def self.convert_date_to_days
    Incidenttype_Borough.all.each do |i|
      i.open_date = i.open_date.to_date
      # binding.pry
    end
  end

end
