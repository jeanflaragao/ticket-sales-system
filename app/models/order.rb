class Order < ApplicationRecord
  has_many :order_items, dependent: :destroy
  has_many :shows, through: :order_items

# Validations
  validates :customer_email, 
            presence: true, 
            format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :status, 
            inclusion: { in: %w[pending confirmed cancelled failed] }
  validates :total, 
            numericality: { greater_than_or_equal_to: 0 }
  
  # Scopes
  scope :pending, -> { where(status: 'pending') }
  scope :confirmed, -> { where(status: 'confirmed') }
  scope :by_customer, ->(email) { where(customer_email: email) }
  scope :total_between, ->(min, max) { 
    where(total: min..max) 
  }
  scope :recent, ->(days = 7) { 
    where('created_at >= ?', days.days.ago) 
  }
  
  # Chainable scopes
  scope :high_value, -> { where('total > ?', 300) }
  
  # Callbacks
  before_save :calculate_total
  
  # Instance methods
  def confirm!
    update(status: 'confirmed')
  end
  
  def cancel!
    update(status: 'cancelled')
  end
  
  def pending?
    status == 'pending'
  end
  
  def confirmed?
    status == 'confirmed'
  end
  
  private
  
  def calculate_total
    self.total = order_items.sum { |item| item.price * item.quantity }
  end
end
