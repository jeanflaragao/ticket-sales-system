class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.string :customer_email, null: false
      t.string :status, null: false, default: 'pending'
      t.decimal :total, precision: 10, scale: 2, default: 0.0

      t.timestamps
    end

    add_index :orders, :customer_email
    add_index :orders, :status
    add_index :orders, :created_at
  end
end
