class AddMissingIndexes < ActiveRecord::Migration
  def change
    add_index :discounts, [:name], unique: true
    add_index :orders,    [:user_id, :status]
    add_index :refunds,   [:order_id]
    add_index :users,     [:remote_id], unique: true
  end
end
