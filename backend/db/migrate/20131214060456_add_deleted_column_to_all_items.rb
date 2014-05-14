class AddDeletedColumnToAllItems < ActiveRecord::Migration
  def change
    [:physical_items, :digital_items, :bundles, :storefront_items].each do |table|
      add_column table, :deleted, :boolean
    end
  end
end
