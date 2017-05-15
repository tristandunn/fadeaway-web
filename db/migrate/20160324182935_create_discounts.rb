class CreateDiscounts < ActiveRecord::Migration
  def change
    create_table :discounts do |t|
      t.string  :name,   null: false
      t.integer :amount, null: false
      t.timestamps null: false
    end
  end
end
