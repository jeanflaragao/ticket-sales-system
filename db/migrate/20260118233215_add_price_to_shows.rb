class AddPriceToShows < ActiveRecord::Migration[7.1]
  def change
    add_column :shows, :price, :decimal, precision: 10, scale: 2, default: 150.0
  end
end