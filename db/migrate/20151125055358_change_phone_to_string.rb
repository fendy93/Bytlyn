class ChangePhoneToString < ActiveRecord::Migration
  def change
  	change_column :deliveries, :phone, :string
  end
end
