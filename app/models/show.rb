class Show < ApplicationRecord
  # Associations
  has_many :order_items, dependent: :restrict_with_error
  has_many :orders, through: :order_items
  
  # Validations
  validates :name, presence: true, uniqueness: true
  validates :total_inventory, 
            numericality: { greater_than_or_equal_to: 0 }
  validates :reserved_inventory, 
            numericality: { greater_than_or_equal_to: 0 }
  validates :sold_inventory, 
            numericality: { greater_than_or_equal_to: 0 }
  
  # Custom validation
  validate :inventory_cannot_exceed_total
  
  # Scopes
  scope :available, -> { 
    where('total_inventory > sold_inventory + reserved_inventory') 
  }
  scope :sold_out, -> { 
    where('total_inventory <= sold_inventory + reserved_inventory') 
  }
  
  # Instance methods
  def available_inventory
    total_inventory - reserved_inventory - sold_inventory
  end
  
  def sold_out?
    available_inventory <= 0
  end
  
  def percentage_sold
    return 0 if total_inventory.zero?
    (sold_inventory.to_f / total_inventory * 100).round(2)
  end
  
  private
  
  def inventory_cannot_exceed_total
    return unless total_inventory.present?
    
    used = reserved_inventory + sold_inventory
    if used > total_inventory
      errors.add(:base, "Reserved + sold cannot exceed total inventory")
    end
  end
end