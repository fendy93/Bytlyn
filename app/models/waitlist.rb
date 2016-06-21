class Waitlist < ActiveRecord::Base

    validates :people, presence: true
    validates :cust_id, presence: true
    validates :rest_id, presence: true
    belongs_to :customer
    belongs_to :restaurant
    belongs_to :user

    def self.get_restaurant_waitlist(user_id)
        return Waitlist.where(rest_id: user_id, status: 1).order(:created_at)
    end

    def self.get_customer_waitlist(user_id)
        list_and_position = []
        lists = Waitlist.where(cust_id: user_id, status: 1).order(:created_at)
        lists.each do |list|
            this_list = get_restaurant_waitlist(list.rest_id)
            pos = this_list.where('created_at < ?', list.created_at).count + 1
            # pos = this_list.count(:conditions => ['created_at < ?', list.created_at])
            list_and_position << {:list => list, :position => pos}
        end
        return list_and_position
    end

    def self.get_restaurant_waitlist_history(user_id)
        return Waitlist.where(rest_id: user_id).where("status > ?", 1).order(updated_at: :desc)
    end

    def self.get_customer_waitlist_history(user_id)
        list_and_position = []
        lists = Waitlist.where(cust_id: user_id).where("status > ?", 1).order(updated_at: :desc)
        lists.each do |list|
            list_and_position << {:list => list, :position => nil}
        end
        return list_and_position
    end

    def check_params
        if User.find_by(id: cust_id) == nil || User.find_by(id: rest_id) == nil || !User.find_by(id: rest_id).rest
            errors.add(:rest_id, "Invalid restaurant/customer id")
            return false
        end
        if (cust_id == rest_id) #for restaurant to put on their own waitlist
            return true
        end
        if User.find_by(id: cust_id).rest && (cust_id != rest_id)
            return false
        end
        if Waitlist.where(cust_id: cust_id, rest_id: rest_id, status: 1).size > 0
            errors.add(:base, "You have waitlisted on this restaurant")
            return false
        end
        return true
    end

    def self.status_string(status)
        case status
            when 1
                'On Waitlist'
            when 2
                'Got In'
            when 3
                'No Show'
            else
                'Unknown'

        end
    end



end
