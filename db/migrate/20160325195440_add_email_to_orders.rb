class AddEmailToOrders < ActiveRecord::Migration
  def change
    change_table :orders do |t|
      t.string :email, null: false
    end
  end
end
