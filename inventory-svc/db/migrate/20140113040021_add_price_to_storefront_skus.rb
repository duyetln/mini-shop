class AddPriceToStorefrontSkus < ActiveRecord::Migration
  def change
    add_column :storefront_skus, :price_id, :integer
    add_index  :storefront_skus, :price_id
  end
end
