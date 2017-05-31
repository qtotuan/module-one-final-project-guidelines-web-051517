class Borough < ActiveRecord::Base
  has_many :incidenttype_boroughs
  has_many :incidenttypes, through: :incidenttype_boroughs

  validates :name, uniqueness: true
end
