class ChangeHoursFieldToTime < ActiveRecord::Migration
  def change
    remove_column :hours, :open
    remove_column :hours, :close
    add_column :hours, :open, :time
    add_column :hours, :close, :time
  end
end
