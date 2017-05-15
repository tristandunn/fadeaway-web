class AddReleasedAtToReleases < ActiveRecord::Migration
  def change
    change_table :releases do |t|
      t.datetime :released_at
    end
  end
end
