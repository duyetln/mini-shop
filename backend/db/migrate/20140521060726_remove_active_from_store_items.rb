class RemoveActiveFromStoreItems < ActiveRecord::Migration
  def up
    remove_column :store_items, :active
  end

  def down
    add_column :store_items, :active, :boolean
  end
end
