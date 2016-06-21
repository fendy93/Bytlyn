class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.integer :user_id, null: false
      t.integer :phone_number, null: false
      t.timestamps null: false
    end
  end
end
