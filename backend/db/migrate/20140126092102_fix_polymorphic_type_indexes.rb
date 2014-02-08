class FixPolymorphicTypeIndexes < ActiveRecord::Migration
  def up
    remove_index :bundlings, :bundled_sku_type
    remove_index :bundlings, :bundled_sku_id
    remove_index :storefront_skus, :sku_type
    remove_index :storefront_skus, :sku_id

    add_index    :bundlings, [:bundled_sku_type, :bundled_sku_id]
    add_index    :storefront_skus, [:sku_type, :sku_id]
  end

  def down
    remove_index :storefront_skus, [:sku_type, :sku_id]
    remove_index :bundlings, [:bundled_sku_type, :bundled_sku_id]

    add_index    :storefront_skus, :sku_id
    add_index    :storefront_skus, :sku_type
    add_index    :bundlings, :bundled_sku_id
    add_index    :bundlings, :bundled_sku_type
  end
end
