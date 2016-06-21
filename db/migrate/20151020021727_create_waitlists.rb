class CreateWaitlists < ActiveRecord::Migration
  def change
    create_table :waitlists do |t|
      t.integer :rest_id, null: false
      t.integer :cust_id, null: false
      t.integer :people, null: false
      t.timestamps null: false
    end
  end
end
