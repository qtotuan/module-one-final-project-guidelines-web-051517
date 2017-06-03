class Borough < ActiveRecord::Base
  has_many :incidenttype_boroughs
  has_many :incidenttypes, through: :incidenttype_boroughs

  validates :name, uniqueness: true


  def self.list_names
    Borough.all.each do |borough|
      puts "\t#{borough.name}"
    end
  end

end
