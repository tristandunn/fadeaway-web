class AssociateCrashWithUser < ActiveRecord::Migration
  def change
    change_table :crashes do |t|
      t.belongs_to :user, null: true
    end
  end
end
