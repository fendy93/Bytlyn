class ChangeTypeName < ActiveRecord::Migration
  def change
    rename_column :restaurants, :type, :rest_type
  end
end
