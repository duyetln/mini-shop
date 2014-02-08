class CreateDigitalSkusTable < ActiveRecord::Migration
  def up
    create_table :digital_skus do |t|
      t.string   :title
      t.string   :description
      t.boolean  :active
      t.timestamps
    end
  end

  def down
    drop_table    :digital_skus
  end
end
