class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.string :description
      t.string :event_image
      t.string :venue
      t.decimal :location_lati
      t.decimal :location_long
      t.integer :category
      t.integer :subcategories
      t.integer :cost
      t.date :date
      t.time :time

      t.timestamps
    end
  end
end
