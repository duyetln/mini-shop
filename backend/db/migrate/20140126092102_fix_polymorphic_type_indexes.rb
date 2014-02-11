class FixPolymorphicTypeIndexes < ActiveRecord::Migration
  def up
    remove_index :bundlings, :bundled_item_type
    remove_index :bundlings, :bundled_item_id
    remove_index :storefront_items, :item_type
    remove_index :storefront_items, :item_id

    add_index    :bundlings, [:bundled_item_type, :bundled_item_id]
    add_index    :storefront_items, [:item_type, :item_id]
  end

  def down
    remove_index :storefront_items, [:item_type, :item_id]
    remove_index :bundlings, [:bundled_item_type, :bundled_item_id]

    add_index    :storefront_items, :item_id
    add_index    :storefront_items, :item_type
    add_index    :bundlings, :bundled_item_id
    add_index    :bundlings, :bundled_item_type
  end
end
