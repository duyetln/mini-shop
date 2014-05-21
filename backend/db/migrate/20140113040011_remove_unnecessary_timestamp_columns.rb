class RemoveUnnecessaryTimestampColumns < ActiveRecord::Migration
  def up
    remove_column :physical_items, :updated_at
    remove_column :digital_items, :updated_at
    remove_column :bundles, :updated_at

    remove_column :bundleds, :updated_at
    remove_column :bundleds, :created_at

    remove_column :store_items, :updated_at
  end

  def down
    add_column :store_items, :updated_at, :datetime

    add_column :bundleds, :created_at, :datetime
    add_column :bundleds, :updated_at, :datetime

    add_column :bundles, :updated_at, :datetime
    add_column :digital_items, :updated_at, :datetime
    add_column :physical_items, :updated_at, :datetime
  end
end
