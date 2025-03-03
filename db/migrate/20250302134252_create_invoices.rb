class CreateInvoices < ActiveRecord::Migration[7.2]
  def change
    create_table :invoices do |t|
      t.string :customer_name
      t.string :customer_email
      t.string :status
      t.decimal :discount
      t.decimal :total_amount

      t.timestamps
    end
  end
end
