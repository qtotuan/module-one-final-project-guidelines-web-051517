class Incidenttype < ActiveRecord::Base
  has_many :incidenttype_boroughs
  has_many :boroughs, through: :incidenttype_boroughs

  validates :name, uniqueness: true

  def self.list_names
    Incidenttype.all.each do |i|
      puts "\t#{i.name}"
    end
  end
end
