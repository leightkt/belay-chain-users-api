class CreateGyms < ActiveRecord::Migration[6.1]
  def change
    create_table :gyms do |t|
      t.string :name 
      t.string :street_address
      t.string :city
      t.string :state
      t.integer :zip_code
      t.string :email
      t.string :password_digest
      t.timestamps
    end
  end
end
