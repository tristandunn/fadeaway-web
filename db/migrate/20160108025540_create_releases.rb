class CreateReleases < ActiveRecord::Migration
  def change
    create_table :releases do |t|
      t.string   :version,    null: false
      t.datetime :created_at, null: false
    end
  end
end
