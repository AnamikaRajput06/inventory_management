class Product < ApplicationRecord
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items

  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :low_stock_threshold, presence: true, numericality: { greater_than_or_equal_to: 0 }

  def reduce_quantity!(amount)
    with_lock do
      if self.quantity >= amount
        self.quantity -= amount
        save!
      else
        raise StandardError, "Insufficient quantity available"
      end
    end
  end
end
