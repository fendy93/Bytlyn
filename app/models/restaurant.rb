class Restaurant < ActiveRecord::Base
    validates :user_id, uniqueness: true
	belongs_to :user
	has_many :waitlist
    has_many :rating
    has_many :hours, :foreign_key => 'rest_id', :primary_key => 'user_id'
    has_many :menus, :foreign_key => 'rest_id', :primary_key => 'user_id'
    # validate :has_seven_hours
    accepts_nested_attributes_for :hours, :reject_if => lambda { |a| a[:content].blank? }, :allow_destroy => true

    # def has_seven_hours
    #     errors.add(:hours, "hours not 7") if hours.size != 7
    # end

end
