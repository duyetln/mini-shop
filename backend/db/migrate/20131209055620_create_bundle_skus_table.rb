class CreateBundleSkusTable < ActiveRecord::Migration
  def up
    create_table :bundle_skus do |t|
      t.string   :title
      t.string   :description
      t.boolean  :active
      t.timestamps
    end
  end

  def down
    drop_table    :bundle_skus
  end
end
