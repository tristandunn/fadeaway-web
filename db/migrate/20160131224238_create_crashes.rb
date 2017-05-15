class CreateCrashes < ActiveRecord::Migration
  def change
    create_table :crashes do |t|
      t.string   :version,    null: false
      t.json     :system,     null: false
      t.datetime :created_at, null: false
    end
  end
end
