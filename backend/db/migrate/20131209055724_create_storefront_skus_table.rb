class CreateStorefrontSkusTable < ActiveRecord::Migration
  def up
    create_table :storefront_skus do |t|
      t.string   :title
      t.string   :description
      t.boolean  :active
      t.integer  :sku_id
      t.string   :sku_type
      t.timestamps
    end

    add_index    :storefront_skus, :sku_id
    add_index    :storefront_skus, :sku_type
  end

  def down
    remove_index :storefront_skus, :sku_type
    remove_index :storefront_skus, :sku_id
    drop_table   :storefront_skus
  end
end
