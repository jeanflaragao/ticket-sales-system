# db/seeds.rb
puts 'Cleaning database...'
OrderItem.destroy_all
Order.destroy_all
Show.destroy_all

puts 'Creating shows...'

shows_data = [
  {
    name: 'Hamilton',
    total_inventory: 100,
    reserved_inventory: 10,
    sold_inventory: 45,
    price: 150.00
  },
  {
    name: 'Wicked',
    total_inventory: 150,
    reserved_inventory: 20,
    sold_inventory: 67,
    price: 125.00
  },
  {
    name: 'The Lion King',
    total_inventory: 120,
    reserved_inventory: 5,
    sold_inventory: 38,
    price: 140.00
  },
  {
    name: 'Chicago',
    total_inventory: 75,
    reserved_inventory: 0,
    sold_inventory: 75,
    price: 100.00
  },
  {
    name: 'Phantom of the Opera',
    total_inventory: 200,
    reserved_inventory: 15,
    sold_inventory: 92,
    price: 135.00
  }
]

shows_data.each do |show_data|
  show = Show.create!(show_data)
  puts "Created: #{show.name} - $#{show.price} (#{show.available_inventory} available)"
end

puts "\nCreating sample orders..."

# Order 1
order1 = Order.create!(
  customer_email: 'alice@example.com',
  status: 'confirmed'
)

order1.order_items.create!([
                             { show: Show.find_by(name: 'Hamilton'), quantity: 2, price: 150.00 },
                             { show: Show.find_by(name: 'Wicked'), quantity: 1, price: 125.00 }
                           ])

order1.save!
puts "Created Order ##{order1.id} for #{order1.customer_email} - Total: $#{order1.total}"

# Order 2
order2 = Order.create!(
  customer_email: 'bob@example.com',
  status: 'pending'
)

order2.order_items.create!([
                             { show: Show.find_by(name: 'The Lion King'), quantity: 3,
                               price: 140.00 }
                           ])

order2.save!
puts "Created Order ##{order2.id} for #{order2.customer_email} - Total: $#{order2.total}"

# Order 3
order3 = Order.create!(
  customer_email: 'alice@example.com',
  status: 'confirmed'
)

order3.order_items.create!([
                             { show: Show.find_by(name: 'Phantom of the Opera'), quantity: 2,
                               price: 135.00 },
                             { show: Show.find_by(name: 'Chicago'), quantity: 1, price: 100.00 }
                           ])

order3.save!
puts "Created Order ##{order3.id} for #{order3.customer_email} - Total: $#{order3.total}"

puts "\n=== Summary ==="
puts "Shows: #{Show.count}"
puts "Orders: #{Order.count}"
puts "Order Items: #{OrderItem.count}"
puts "Total Revenue: $#{Order.confirmed.sum(:total)}"
