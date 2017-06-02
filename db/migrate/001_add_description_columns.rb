class AddDescriptionColumns < ActiveRecord::Migration[5.0]
  def change
    add_column :incidenttype_boroughs, :description, :string
  end
end
