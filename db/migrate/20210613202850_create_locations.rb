class CreateLocations < ActiveRecord::Migration[6.1]
  def change
    create_table :locations do |t|
      t.string :name
      t.string :street
      t.string :number
      t.string :complement
      t.string :city
      t.string :state
      t.string :zip_code

      t.timestamps
    end
  end
end
