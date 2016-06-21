class AddHoursAndRestaurantDetails < ActiveRecord::Migration
  def change
    add_column :restaurants, :rating, :integer
    add_column :restaurants, :price, :integer
    add_column :restaurants, :type, :string
    add_column :restaurants, :description, :text

    create_table :hours do |t|
      t.integer :rest_id, null: false
      t.integer :day_id, null: false
      t.integer :open
      t.integer :close
      t.timestamps null: false
    end
  end
end
