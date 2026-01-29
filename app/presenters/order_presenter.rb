class OrderPresenter
  def initialize(order)
    @order = order
  end

  def as_json
    {
      id: @order.id,
      customer: customer_info,
      items: items_info,
      pricing: pricing_info,
      status: status_info,
      timestamps: timestamp_info
    }
  end

  private

  def customer_info
    {
      email: @order.customer_email,
      order_count: Order.where(customer_email: @order.customer_email).count
    }
  end

  def items_info
    @order.order_items.map do |item|
      {
        show_name: item.show.name,
        quantity: item.quantity,
        unit_price: item.price,
        subtotal: item.price * item.quantity
      }
    end
  end

  def pricing_info
    {
      subtotal: @order.order_items.sum { |i| i.price * i.quantity },
      tax: calculate_tax,
      total: @order.total,
      currency: 'USD'
    }
  end

  def status_info
    {
      current: @order.status,
      confirmed_at: @order.updated_at,
      can_cancel: @order.status == 'pending'
    }
  end

  def timestamp_info
    {
      created_at: @order.created_at.iso8601,
      updated_at: @order.updated_at.iso8601,
      age_in_minutes: ((Time.current - @order.created_at) / 60).round
    }
  end

  def calculate_tax
    (@order.total * 0.08).round(2)
  end
end
