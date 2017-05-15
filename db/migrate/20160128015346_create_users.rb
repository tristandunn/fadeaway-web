class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :remote_id, null: false
      t.timestamps null: false
    end
  end
end
