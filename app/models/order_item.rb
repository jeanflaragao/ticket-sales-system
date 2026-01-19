class OrderItem < ApplicationRecord
  # Associations
  belongs_to :order
  belongs_to :show
  
  # Validations
  validates :quantity, 
            numericality: { greater_than: 0 }
  validates :price, 
            numericality: { greater_than_or_equal_to: 0 }
  validates :show_id, uniqueness: { scope: :order_id }
  
  # Callbacks
  before_validation :set_price_from_show, on: :create
  
  # Instance methods
  def subtotal
    price * quantity
  end
  
  private
  
  def set_price_from_show
    self.price ||= show.price if show.present?
  end
end