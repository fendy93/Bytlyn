class CreateDeliveries < ActiveRecord::Migration
  def change
    create_table :deliveries do |t|
      t.integer :phone, null: false
      t.integer :rest_id, null: false
      t.integer :version, null: false
      t.integer :user_id, null: false
      t.string :address, null: false
      t.float :total, null: false

      t.timestamps null: false
    end
  end
end
