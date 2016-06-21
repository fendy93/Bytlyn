class AddStatusToDelivery < ActiveRecord::Migration
  def change
    add_column :deliveries, :status, :integer, null:false
  end
end
