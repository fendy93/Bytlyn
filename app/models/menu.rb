class Menu < ActiveRecord::Base
	belongs_to :restaurant
	has_attached_file :avatar, styles: { medium: "300x300>", thumb: "300x300>" }, default_url: "/images/:style/missing.png"
	validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/
	validates :rest_id, presence: true
	validates :name, presence: true
    validates :price, presence: true

	def self.get_restaurant_menu(user_id)
		if Restaurant.where(user_id: user_id).first != nil
	        return Menu.where(rest_id: user_id).order(:created_at)
	    else
	    	return false
	    end
    end
end
