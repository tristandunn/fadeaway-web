class AddRemoteIdToOrders < ActiveRecord::Migration
  def change
    change_table :orders do |t|
      t.string :remote_id
    end
  end
end
