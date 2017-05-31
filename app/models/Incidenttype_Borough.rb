require "pry"

class Incidenttype_Borough < ActiveRecord::Base
  belongs_to :borough
  belongs_to :incidenttype

  def self.all_dates
    self.all.map do |i|
      i.open_date = i.open_date.to_date.year
    end
  end

end
