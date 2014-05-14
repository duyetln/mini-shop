class RemoveUnnecessaryTimestampColumns < ActiveRecord::Migration
  def up
    remove_column :physical_items,   :updated_at
    remove_column :digital_items,    :updated_at
    remove_column :bundles,     :updated_at

    remove_column :bundlings,       :updated_at
    remove_column :bundlings,       :created_at

    remove_column :storefront_items, :updated_at
  end

  def down
    add_column :storefront_items, :updated_at, :datetime

    add_column :bundlings,       :created_at, :datetime
    add_column :bundlings,       :updated_at, :datetime

    add_column :bundles,     :updated_at, :datetime
    add_column :digital_items,    :updated_at, :datetime
    add_column :physical_items,   :updated_at, :datetime
  end
end
