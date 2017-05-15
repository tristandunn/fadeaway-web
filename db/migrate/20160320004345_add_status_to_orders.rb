class AddStatusToOrders < ActiveRecord::Migration
  def change
    change_table :orders do |t|
      t.integer :status, null: false, default: 0
    end
  end
end
