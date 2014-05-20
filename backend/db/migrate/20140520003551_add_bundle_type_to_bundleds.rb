class AddBundleTypeToBundleds < ActiveRecord::Migration
  def up
    add_column   :bundleds, :bundle_type, :string
    remove_index :bundleds, :bundle_id
    add_index    :bundleds, [:bundle_type, :bundle_id]

    require 'lib/models/inventory/bundled'
    Bundled.update_all(bundle_type: 'Bundle')
  end

  def down
    remove_index  :bundleds, [:bundle_type, :bundle_id]
    add_index     :bundleds, :bundle_id
    remove_column :bundleds, :bundle_type
  end
end
