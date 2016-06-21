class CreateCarts < ActiveRecord::Migration
  def change
    create_table :carts do |t|
      t.integer :cust_id, null: false
      t.integer :rest_id, null: false
      t.integer :version, null: false
      t.integer :menu_id, null: false
      t.integer :qty, null: false

      t.timestamps null: false
    end
  end
end
