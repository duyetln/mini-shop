class CreatePurchasesTable < ActiveRecord::Migration
  def up
    create_table :purchases do |t|
      t.integer  :order_id
      t.string   :item_type
      t.integer  :item_id
      t.integer  :currency_id
      t.decimal  :amount, precision: 20, scale: 4
      t.decimal  :tax, precision: 20, scale: 4
      t.integer  :quantity
      t.integer  :payment_id
      t.integer  :fulfillment_id
      t.boolean  :cancelled
      t.boolean  :removed
      t.datetime :created_at
    end

    add_index    :purchases, :order_id
    add_index    :purchases, [:item_type, :item_id]
  end

  def down
    remove_index :purchases, [:item_type, :item_id]
    remove_index :purchases, :order_id
    drop_table   :purchases
  end
end
