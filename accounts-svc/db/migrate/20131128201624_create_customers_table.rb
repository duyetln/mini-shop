class CreateCustomersTable < ActiveRecord::Migration
  def up
    create_table  :customers do |t|
      t.string    :uuid
      t.string    :first_name
      t.string    :last_name
      t.string    :email
      t.date      :birthdate
      t.string    :password
      t.string    :confirmation_code
      t.timestamps
    end

    add_index     :customers, :uuid
  end

  def down
    remove_index  :customers, :uuid
    drop_table    :customers
  end
end
