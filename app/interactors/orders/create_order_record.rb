class Orders::CreateOrderRecord
  include Interactor

  def call
    context.order = Order.create!(
      customer_email: context.customer_email,
      status: 'pending'
    )
  end
end
