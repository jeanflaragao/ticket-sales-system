class Orders::FinalizeInventory
  include Interactor

  def call
    context.order.order_items.each do |item|
      show = item.show

      show.update!(
        reserved_inventory: show.reserved_inventory - item.quantity,
        sold_inventory: show.sold_inventory + item.quantity
      )
    end

    context.order.update!(status: 'confirmed')
  end
end
