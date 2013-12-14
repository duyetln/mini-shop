class AddRemovedColumnToAllSkus < ActiveRecord::Migration
  def change
    [:physical_skus, :digital_skus, :bundle_skus, :storefront_skus].each do |table|
      add_column table, :removed, :boolean
    end
  end
end
