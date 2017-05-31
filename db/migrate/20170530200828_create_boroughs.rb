class CreateBoroughs < ActiveRecord::Migration[5.0]
  def change
      create_table :boroughs do |t|
        t.string :name

        t.timestamp
      end
  end
end
