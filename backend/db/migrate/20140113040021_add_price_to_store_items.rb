class AddPriceToStoreItems < ActiveRecord::Migration
  def change
    add_column :store_items, :price_id, :integer
    add_index  :store_items, :price_id
  end
end
