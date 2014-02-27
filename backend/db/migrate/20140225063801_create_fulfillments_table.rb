class CreateFulfillmentsTable < ActiveRecord::Migration
  def up
    create_table :fulfillments do |t|
      t.string   :type
      t.integer  :order_id
      t.string   :item_type
      t.integer  :item_id
      t.boolean  :fulfilled
      t.datetime :fulfilled_at
      t.datetime :created_at
    end

    add_index    :fulfillments, :type
    add_index    :fulfillments, :order_id
    add_index    :fulfillments, [:item_type, :item_id]
  end

  def down
    remove_index :fulfillments, [:item_type, :item_id]
    remove_index :fulfillments, :order_id
    remove_index :fulfillments, :type
    drop_table   :fulfillments
  end
end
