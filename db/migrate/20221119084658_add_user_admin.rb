class AddUserAdmin < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :admin, :boolean, null: false
  end
end
