class AddAmountToOrders < ActiveRecord::Migration
  def change
    change_table :orders do |t|
      t.integer :amount, null: false
    end
  end
end
