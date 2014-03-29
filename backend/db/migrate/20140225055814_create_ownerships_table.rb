class CreateOwnershipsTable < ActiveRecord::Migration
  def up
    create_table :ownerships do |t|
      t.integer  :user_id
      t.integer  :order_id
      t.string   :item_type
      t.string   :item_id
      t.integer  :qty
      t.datetime :created_at
    end

    add_index    :ownerships, :user_id
    add_index    :ownerships, [:item_type, :item_id]
  end

  def down
    remove_index :ownerships, [:item_type, :item_id]
    remove_index :ownerships, :user_id
    drop_table   :ownerships
  end
end
