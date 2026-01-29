class AddIndexesToOrders < ActiveRecord::Migration[7.1]
  def change
    # Speed up WHERE clauses
    add_index :orders, :status
    add_index :orders, :customer_email
    add_index :orders, :created_at

    # Composite index for common query pairs
    add_index :orders, %i[customer_email status]
    add_index :orders, %i[status created_at]

    # Unique index
    add_index :order_items, %i[order_id show_id], unique: true
  end
end
