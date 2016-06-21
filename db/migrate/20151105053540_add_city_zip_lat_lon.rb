class AddCityZipLatLon < ActiveRecord::Migration
  def change
    add_column :restaurants, :city, :string
    add_column :restaurants, :zip, :string
    add_column :restaurants, :lat, :decimal
    add_column :restaurants, :lon, :decimal
  end
end
