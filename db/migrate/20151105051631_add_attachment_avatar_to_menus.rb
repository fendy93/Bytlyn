class AddAttachmentAvatarToMenus < ActiveRecord::Migration
  def self.up
    change_table :menus do |t|
      t.attachment :avatar
    end
  end

  def self.down
    remove_attachment :menus, :avatar
  end
end
