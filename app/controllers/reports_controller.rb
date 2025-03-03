class ReportsController < ApplicationController
  before_action :require_login

  def index
    @start_date = params[:start_date]&.to_date || 1.month.ago.to_date
    @end_date = params[:end_date]&.to_date || Date.current

    @total_sales = Invoice.paid
                         .where(created_at: @start_date.beginning_of_day..@end_date.end_of_day)
                         .sum(:total_amount)

    @top_products = Product.joins(:invoice_items)
                          .joins(:invoices)
                          .where(invoices: { status: Invoice.statuses[:paid], created_at: @start_date.beginning_of_day..@end_date.end_of_day })
                          .group('products.id')
                          .select('products.*, SUM(invoice_items.quantity) as total_quantity')
                          .order('total_quantity DESC')
                          .limit(10)
  end
end
