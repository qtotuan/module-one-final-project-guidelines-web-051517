class CreateIncidenttypes < ActiveRecord::Migration[5.0]
  def change
    create_table :incidenttypes do |t|
      t.string :name

      t.timestamp
    end
  end
end
