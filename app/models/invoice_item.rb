class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :product

  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validate :check_product_quantity, if: :quantity_changed?
  before_save :set_total_price
  after_save :reduce_product_quantity

  def low_stock?
    remaining_quantity = product.quantity
    remaining_quantity <= product.low_stock_threshold
  end

  def low_stock_message
    "Low stock alert: #{product.name} has only #{product.quantity} units remaining (Threshold: #{product.low_stock_threshold})"
  end

  private

  def check_product_quantity
    return unless product && quantity

    available_quantity = product.quantity
    if quantity > available_quantity
      errors.add(:quantity, "cannot exceed available stock (#{available_quantity} available)")
    end
  end

  def set_total_price
    self.total_price = quantity * product.price
  end

  def reduce_product_quantity
    product.reduce_quantity!(quantity)
  end
end
