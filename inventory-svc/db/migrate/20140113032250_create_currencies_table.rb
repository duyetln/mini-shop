class CreateCurrenciesTable < ActiveRecord::Migration
  def up
    create_table :currencies do |t|
      t.string   :code
    end

    add_index    :currencies, :code
  end

  def down
    remove_index :currencies, :code
    drop_table   :currencies
  end
end
