class AddDeletedColumnToAllSkus < ActiveRecord::Migration
  def change
    [:physical_skus, :digital_skus, :bundle_skus, :storefront_skus].each do |table|
      add_column table, :deleted, :boolean
    end
  end
end
