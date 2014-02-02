class CreatePurchasesTable < ActiveRecord::Migration
  def up
    create_table :purchases do |t|
      t.integer  :user_id
      t.integer  :payment_method_id
      t.integer  :billing_address_id
      t.integer  :shipping_address_id
      t.integer  :payment_id
      t.boolean  :submitted
      t.datetime :submitted_at
      t.datetime :created_at
    end

    add_index    :purchases, :user_id
  end

  def down
    remove_index :purchases, :user_id
    drop_table   :purchases
  end
end
