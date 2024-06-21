class SwitchMemberIds < ActiveRecord::Migration[6.0]
  def change
    change_table :members do |t|
      t.integer :group_id
    end

    change_table :groups do |t|
      t.remove :member_id
    end
  end
end
