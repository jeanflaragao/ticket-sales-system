class Orders::ReserveInventory
  include Interactor

  def call
    context.items.each do |item|
      show = Show.find(item[:show_id])

      show.update!(
        reserved_inventory: show.reserved_inventory + item[:quantity]
      )
    end
  end

  def rollback
    # Automatically called if later interactor fails
    context.items.each do |item|
      show = Show.find(item[:show_id])

      show.update!(
        reserved_inventory: show.reserved_inventory - item[:quantity]
      )
    end
  end
end
