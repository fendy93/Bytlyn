class CreateMenus < ActiveRecord::Migration
  def change
    create_table :menus do |t|
      t.integer :rest_id, null: false
      t.string :name, null: false
      t.string :description
      t.integer :price, null: false

      t.timestamps null: false
    end
  end
end
