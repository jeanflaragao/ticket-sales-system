puts "Cleaning database..."
Show.destroy_all

puts "Creating shows..."

shows = [
  {
    name: "Hamilton",
    total_inventory: 100,
    reserved_inventory: 10,
    sold_inventory: 45
  },
  {
    name: "Wicked",
    total_inventory: 150,
    reserved_inventory: 20,
    sold_inventory: 67
  },
  {
    name: "The Lion King",
    total_inventory: 120,
    reserved_inventory: 5,
    sold_inventory: 38
  },
  {
    name: "Chicago",
    total_inventory: 75,
    reserved_inventory: 0,
    sold_inventory: 75  # Sold out
  },
  {
    name: "Phantom of the Opera",
    total_inventory: 200,
    reserved_inventory: 15,
    sold_inventory: 92
  }
]

shows.each do |show_data|
  show = Show.create!(show_data)
  puts "Created: #{show.name} (#{show.available_inventory} available)"
end

puts "\nTotal shows: #{Show.count}"
puts "Available shows: #{Show.available.count}"
puts "Sold out shows: #{Show.sold_out.count}"