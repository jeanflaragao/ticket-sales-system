class BulkOrderForm
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :customer_email, :customer_name, :payment_method, :coupon_code
  attr_reader :items, :order

  validates :customer_email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :customer_name, presence: true
  validates :payment_method, inclusion: { in: %w[credit_card paypal gift_card] }
  validate :validate_items_presence
  validate :validate_inventory_availability

  def initialize(attributes = {})
    @items = []
    super
  end

  def add_item(show_id, quantity)
    @items << { show_id: show_id, quantity: quantity }
  end

  def save
    return false unless valid?

    ActiveRecord::Base.transaction do
      create_order
      create_order_items
      apply_coupon if coupon_code.present?
      update_inventory
    end

    true
  rescue ActiveRecord::RecordInvalid
    false
  end

  def total
    return 0 if @order.nil?

    @order.total
  end

  private

  def validate_items_presence
    errors.add(:items, 'must have at least one item') if @items.empty?
  end

  def validate_inventory_availability
    @items.each do |item|
      show = Show.find_by(id: item[:show_id])

      unless show
        errors.add(:items, "Show #{item[:show_id]} not found")
        next
      end

      if show.available_inventory < item[:quantity]
        errors.add(:items, "Insufficient inventory for #{show.name}")
      end
    end
  end

  def create_order
    @order = Order.create!(
      customer_email: customer_email,
      status: 'pending'
    )
  end

  def create_order_items
    @items.each do |item|
      show = Show.find(item[:show_id])

      @order.order_items.create!(
        show: show,
        quantity: item[:quantity],
        price: show.price
      )
    end
  end

  def apply_coupon
    # Discount logic here
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
