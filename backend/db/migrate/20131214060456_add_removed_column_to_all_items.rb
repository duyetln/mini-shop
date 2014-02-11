class AddRemovedColumnToAllItems < ActiveRecord::Migration
  def change
    [:physical_items, :digital_items, :bundle_items, :storefront_items].each do |table|
      add_column table, :removed, :boolean
    end
  end
end
