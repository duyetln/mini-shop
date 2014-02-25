class CreateShipmentsTable < ActiveRecord::Migration
  def up
    create_table :shipments do |t|
      t.integer  :user_id
      t.string   :item_type
      t.integer  :item_id
      t.integer  :shipping_address_id
      t.datetime :created_at
    end

    add_index    :shipments, :user_id
    add_index    :shipments, [:item_type, :item_id]
  end

  def down
    remove_index :shipments, [:item_type, :item_id]
    remove_index :shipments, :user_id
    drop_table   :shipments
  end
end
