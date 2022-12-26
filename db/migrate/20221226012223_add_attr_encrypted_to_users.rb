class AddAttrEncryptedToUsers < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :ec_login_id
    remove_column :users, :ec_login_password
    add_column :users, :encrypted_ec_login_id, :string
    add_column :users, :encrypted_ec_login_id_iv, :string
    add_column :users, :encrypted_ec_login_password, :string
    add_column :users, :encrypted_ec_login_password_iv, :string
  end
end
