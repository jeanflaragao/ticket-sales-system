class CreateOrderService
  attr_reader :errors, :order

  def initialize(params)
    @params = params
    @errors = []
    @order = nil
  end

  def call
    return self unless valid?

    ActiveRecord::Base.transaction do
      create_order
      create_order_items
      update_inventory
    end

    self
  rescue ActiveRecord::RecordInvalid => e
    @errors << e.message
    self
  end

  def success?
    @errors.empty? && @order.present?
  end

  private

  def valid?
    validate_email
    validate_items_presence
    validate_inventory
    @errors.empty?
  end

  def validate_email
    email = @params[:customer_email]
    return if email.present? && email.match?(/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i)

    @errors << 'Invalid email address'
  end

  def validate_items_presence
    return if @params[:items].present?

    @errors << 'Order must have at least one item'
  end

  def validate_inventory
    @params[:items]&.each do |item|
      show = Show.find_by(id: item[:show_id])

      unless show
        @errors << "Show #{item[:show_id]} not found"
        next
      end

      quantity = item[:quantity].to_i
      @errors << "Insufficient inventory for #{show.name}" if show.available_inventory < quantity
    end
  end

  def create_order
    @order = Order.create!(
      customer_email: @params[:customer_email],
      status: 'pending'
    )
  end

  def create_order_items
    @params[:items].each do |item|
      show = Show.find(item[:show_id])

      @order.order_items.create!(
        show: show,
        quantity: item[:quantity].to_i,
        price: show.price
      )
    end
  end

  def update_inventory
    @order.order_items.each do |item|
      show = item.show
      show.update!(
        sold_inventory: show.sold_inventory + item.quantity
      )
    end

    @order.save!
  end
end
