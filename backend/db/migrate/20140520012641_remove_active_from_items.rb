class RemoveActiveFromItems < ActiveRecord::Migration
  def up
    remove_column :physical_items, :active
    remove_column :digital_items, :active
    remove_column :bundles, :active
  end

  def down
    add_column :bundles, :active, :boolean
    add_column :digital_items, :active, :boolean
    add_column :physical_items, :active, :boolean
  end
end
