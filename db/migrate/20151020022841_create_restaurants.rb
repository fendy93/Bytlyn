class CreateRestaurants < ActiveRecord::Migration
  def change
    create_table :restaurants do |t|
      t.integer :user_id, null: false
      t.string :address
      t.string :hours
      t.timestamps null: false
    end
  end
end
