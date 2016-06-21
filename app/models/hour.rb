class Hour < ActiveRecord::Base
    validates_uniqueness_of :rest_id, :scope => [:day_id]
    validates :rest_id, presence: true
    validates :day_id, presence: true
    validate :validate_day_id
    belongs_to :restaurant, :foreign_key => 'rest_id', :primary_key => 'user_id'
    validate :validate_open_close_hours

    def validate_day_id
        if day_id != nil
            errors.add(:day_id, "not within range") if day_id > 7 or day_id < 1
        end
    end
    def validate_open_close_hours
        if (open == nil && close != nil) || (open != nil && close == nil) 
            errors.add(:open, "hour and close hour should not be empty")
        end
        if open != nil && close != nil
        #     errors.add(:open, "hour not within range") if open > 24 or open < 1
        #     errors.add(:close, "hour not within range") if close > 24 or close < 1
            
            errors.add(:open, "hour should be before close hour") if open > close
        end
    end

end
