class AddDetailsToReleases < ActiveRecord::Migration
  def change
    change_table :releases do |t|
      t.text :description, null: false
      t.json :logs,        null: false
    end
  end
end
