class CreateStorefrontItemsTable < ActiveRecord::Migration
  def up
    create_table :storefront_items do |t|
      t.string   :title
      t.string   :description
      t.boolean  :active
      t.integer  :item_id
      t.string   :item_type
      t.timestamps
    end

    add_index    :storefront_items, :item_id
    add_index    :storefront_items, :item_type
  end

  def down
    remove_index :storefront_items, :item_type
    remove_index :storefront_items, :item_id
    drop_table   :storefront_items
  end
end
