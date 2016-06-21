class AddNameToWaitlist < ActiveRecord::Migration
  def change
    add_column :waitlists, :name, :string
  end
end
