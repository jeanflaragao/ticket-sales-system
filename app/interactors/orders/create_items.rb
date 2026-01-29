class Orders::CreateItems
  include Interactor

  def call
    context.items.each do |item|
      show = Show.find(item[:show_id])

      context.order.order_items.create!(
        show: show,
        quantity: item[:quantity],
        price: show.price
      )
    end
  end
end
