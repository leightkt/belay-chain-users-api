class AddphoneToGym < ActiveRecord::Migration[6.1]
  def change
    add_column :gyms, :phone, :string
  end
end
