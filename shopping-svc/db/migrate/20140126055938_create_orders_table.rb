class CreateOrdersTable < ActiveRecord::Migration
  def up
    create_table :orders do |t|
      t.string   :uuid
      t.integer  :user_id
      t.integer  :payment_method_id
      t.integer  :billing_address_id
      t.integer  :shipping_address_id
      t.datetime :created_at
    end

    add_index    :orders, :uuid
    add_index    :orders, :user_id
  end

  def down
    remove_index :orders, :user_id
    remove_index :orders, :uuid
    drop_table   :orders
  end
end
