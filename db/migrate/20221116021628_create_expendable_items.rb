class CreateExpendableItems < ActiveRecord::Migration[6.0]
  def change
    create_table :expendable_items do |t|
      t.string :name, null:false
      t.integer :amount_of_product, null:false
      t.datetime :deadline_on
      t.string :image
      t.integer :amount_to_use, null:false
      t.integer :frequency_of_use, null:false
      t.text :product_url
      t.boolean :auto_buy, null:false, default: false

      t.timestamps
    end
  end
end
