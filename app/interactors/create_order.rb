class CreateOrder
  include Interactor

  # Input: context.customer_email, context.items
  # Output: context.order (if success)

  def call
    validate_input
    create_order
    create_order_items
    update_inventory
    send_confirmation
  rescue StandardError => e
    context.fail!(error: e.message)
  end

  private

  def validate_input
    context.fail!(error: 'Email is required') unless context.customer_email.present?

    return if context.items.present?

    context.fail!(error: 'Items are required')
  end

  def create_order
    context.order = Order.create!(
      customer_email: context.customer_email,
      status: 'pending'
    )
  end

  def create_order_items
    context.items.each do |item|
      show = Show.find(item[:show_id])

      context.order.order_items.create!(
        show: show,
        quantity: item[:quantity],
        price: show.price
      )
    end
  end

  def update_inventory
    context.order.order_items.each do |item|
      show = item.show
      show.update!(
        sold_inventory: show.sold_inventory + item.quantity
      )
    end

    context.order.save!
  end

  def send_confirmation
    # OrderMailer.confirmation(context.order).deliver_later
    Rails.logger.info("Order #{context.order.id} confirmation sent")
  end
end
