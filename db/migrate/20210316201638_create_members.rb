class CreateMembers < ActiveRecord::Migration[6.1]
  def change
    create_table :members do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.integer :gym_member_id
      t.string :password_digest
      t.references :gym, null: false, foreign_key: true
      t.timestamps
    end
  end
end
