class AddPriceToStorefrontItems < ActiveRecord::Migration
  def change
    add_column :storefront_items, :price_id, :integer
    add_index  :storefront_items, :price_id
  end
end
