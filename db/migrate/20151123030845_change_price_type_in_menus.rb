class ChangePriceTypeInMenus < ActiveRecord::Migration
  def self.up
    change_column :menus, :price, :float
  end
 
  def self.down
    change_column :menus, :price, :integer
  end
end
