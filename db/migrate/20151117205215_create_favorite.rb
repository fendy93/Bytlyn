class CreateFavorite < ActiveRecord::Migration
  def change
  	create_table :favorites do |t|
      t.string :cust_id, null: false
      t.string :rest_id, null: false
    end
  end
end
