class CreateStatusesTable < ActiveRecord::Migration
  def up
    create_table :statuses do |t|
      t.integer  :source_id
      t.string   :source_type
      t.integer  :status
      t.datetime :created_at
    end

    add_index    :statuses, [:source_id, :source_type]
  end

  def down
    remove_index :statuses, [:source_id, :source_type]
    drop_table   :statuses
  end
end
