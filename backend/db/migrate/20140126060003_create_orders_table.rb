class CreateOrdersTable < ActiveRecord::Migration
  def up
    create_table :orders do |t|
      t.string   :uuid
      t.integer  :purchase_id
      t.string   :item_type
      t.integer  :item_id
      t.integer  :currency_id
      t.decimal  :amount, precision: 20, scale: 4
      t.decimal  :tax, precision: 20, scale: 4
      t.integer  :qty
      t.boolean  :deleted
      t.integer  :status
      t.datetime :fulfilled_at
      t.datetime :reversed_at
      t.datetime :created_at
    end

    add_index    :orders, :purchase_id
    add_index    :orders, :uuid
    add_index    :orders, [:item_type, :item_id]
  end

  def down
    remove_index :orders, [:item_type, :item_id]
    remove_index :orders, :uuid
    remove_index :orders, :purchase_id
    drop_table   :orders
  end
end
