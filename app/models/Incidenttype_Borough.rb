class Incidenttype_Borough < ActiveRecord::Base
  belongs_to :borough
  belongs_to :incidenttype
end
