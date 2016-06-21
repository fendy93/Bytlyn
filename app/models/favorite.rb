class Favorite < ActiveRecord::Base
	validates :cust_id, presence: true
    validates :rest_id, presence: true
	belongs_to :customer

	#has_attached_file :avatar, styles: { medium: "300x300>", thumb: "300x300>" }, default_url: "/images/:style/missing.png"
	#validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/
	validates :rest_id, presence: true

    def self.get_restaurant_favorite(user_id)
       Favorite.where(cust_id: user_id)
    end

    def check_params
        if User.find_by(id: cust_id) == nil || User.find_by(id: rest_id) == nil || !User.find_by(id: rest_id).rest
            return false
        end
        if (cust_id == rest_id) #for restaurant to put on their own waitlist
            return false
        end
        if User.find_by(id: cust_id).rest && (cust_id != rest_id)
            return false
        end
        if Favorite.where(cust_id: cust_id, rest_id: rest_id).size > 0
            return false
        end
        return true
    end
end
