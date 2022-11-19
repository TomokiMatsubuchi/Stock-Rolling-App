class AddColumnToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :line_alert, :boolean, null: false, default: true
    add_column :users, :ec_login_id, :text
    add_column :users, :ec_login_password, :text
  end
end
