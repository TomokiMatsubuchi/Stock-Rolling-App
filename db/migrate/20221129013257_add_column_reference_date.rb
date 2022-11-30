class AddColumnReferenceDate < ActiveRecord::Migration[6.0]
  def change
    add_column :expendable_items, :reference_date, :datetime, null:false
  end
end
