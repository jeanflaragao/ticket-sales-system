class CreateShows < ActiveRecord::Migration[7.1]
  def change
    create_table :shows do |t|
      t.string :name, null: false
      t.integer :total_inventory, null: false, default: 0
      t.integer :reserved_inventory, null: false, default: 0
      t.integer :sold_inventory, null: false, default: 0

      t.timestamps
    end

    add_index :shows, :name
  end
end
