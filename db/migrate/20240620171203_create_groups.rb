class CreateGroups < ActiveRecord::Migration[6.0]
  def change
    create_table :groups do |t|
      t.references :member, null: false, foreign_key: true

      t.timestamps
    end
  end
end
