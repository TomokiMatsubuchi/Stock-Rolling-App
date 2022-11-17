class AddReferencesToExpendableItems < ActiveRecord::Migration[6.0]
  def change
    add_reference :expendable_items, :user, null: false, foreign_key: true
  end
end
