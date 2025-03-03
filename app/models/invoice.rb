class Invoice < ApplicationRecord
  enum status: {
    pending: 'pending',
    paid: 'paid',
    cancelled: 'cancelled'
  }

  has_many :invoice_items, dependent: :destroy
  has_many :products, through: :invoice_items

  validates :customer_name, presence: true
  validates :customer_email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :status, presence: true, inclusion: { in: statuses.keys }
  validates :discount, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :total_amount, numericality: { greater_than: 0 }
  validates :invoice_items, presence: true, length: { minimum: 1, message: "must have at least one product" }

  accepts_nested_attributes_for :invoice_items, allow_destroy: true, reject_if: :all_blank
  validates_associated :invoice_items

  # Set default values
  after_initialize :set_defaults, if: :new_record?

  def set_defaults
    self.status ||= 'pending'
    self.discount ||= 0
    self.total_amount ||= 0
  end

  # Calculate total amount based on invoice items
  def calculate_total
    items_total = invoice_items.sum(&:total_price)
    discount_amount = items_total * (discount / 100.0)
    self.total_amount = items_total - discount_amount
    save
  end
end
