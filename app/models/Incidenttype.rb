class Incidenttype < ActiveRecord::Base
  has_many :incidenttype_boroughs
  has_many :boroughs, through: :incidenttype_boroughs

  validates :name, uniqueness: true
end
