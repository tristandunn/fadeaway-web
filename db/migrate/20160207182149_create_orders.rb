class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.belongs_to :user, null: false
      t.timestamps        null: false
    end
  end
end
