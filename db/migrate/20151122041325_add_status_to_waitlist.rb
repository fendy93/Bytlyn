class AddStatusToWaitlist < ActiveRecord::Migration
  def change
    add_column :waitlists, :status, :integer, null:false
  end
end
