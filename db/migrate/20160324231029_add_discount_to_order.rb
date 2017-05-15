class AddDiscountToOrder < ActiveRecord::Migration
  def change
    change_table :orders do |t|
      t.belongs_to :discount, null: true
    end
  end
end
