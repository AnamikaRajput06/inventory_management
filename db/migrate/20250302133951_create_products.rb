class CreateProducts < ActiveRecord::Migration[7.2]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.integer :quantity
      t.decimal :price
      t.integer :low_stock_threshold

      t.timestamps
    end
  end
end
