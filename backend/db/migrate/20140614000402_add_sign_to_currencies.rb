class AddSignToCurrencies < ActiveRecord::Migration
  def change
    add_column :currencies, :sign, :string
  end
end
