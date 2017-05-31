class CreateIncidenttypeBoroughs < ActiveRecord::Migration[5.0]
  def change
    create_table :incidenttype_boroughs do |t|
      t.references :borough
      t.references :incidenttype
      t.datetime :open_date
      t.datetime :close_date

      t.timestamp
    end
  end
end
