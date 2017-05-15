class CreateRefunds < ActiveRecord::Migration
  def change
    create_table :refunds do |t|
      t.belongs_to :order,      null: false
      t.string     :remote_id,  null: false
      t.integer    :amount,     null: false
      t.datetime   :created_at, null: false
    end
  end
end
