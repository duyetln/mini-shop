class CreateUsersTable < ActiveRecord::Migration
  def up
    create_table  :users do |t|
      t.string    :uuid
      t.string    :first_name
      t.string    :last_name
      t.string    :email
      t.date      :birthdate
      t.string    :password
      t.string    :actv_code
      t.timestamps
    end

    add_index     :users, :uuid
  end

  def down
    remove_index  :users, :uuid
    drop_table    :users
  end
end
