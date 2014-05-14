class CreateStoreItemsTable < ActiveRecord::Migration
  def up
    create_table :store_items do |t|
      t.string   :name
      t.boolean  :active
      t.integer  :item_id
      t.string   :item_type
      t.timestamps
    end

    add_index    :store_items, :item_id
    add_index    :store_items, :item_type
  end

  def down
    remove_index :store_items, :item_type
    remove_index :store_items, :item_id
    drop_table   :store_items
  end
end
