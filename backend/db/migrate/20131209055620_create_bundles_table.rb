class CreateBundlesTable < ActiveRecord::Migration
  def up
    create_table :bundles do |t|
      t.string   :title
      t.string   :description
      t.boolean  :active
      t.timestamps
    end
  end

  def down
    drop_table    :bundles
  end
end
