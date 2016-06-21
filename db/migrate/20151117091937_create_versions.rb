class CreateVersions < ActiveRecord::Migration
  def change
    create_table :versions do |t|
      t.integer :cust_id, null: false
      t.integer :rest_id, null: false
      t.integer :count, null: false

      t.timestamps null: false
    end
  end
end
