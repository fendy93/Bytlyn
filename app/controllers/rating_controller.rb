class RatingController < ApplicationController

    def create
        if user_signed_in? && !current_user.rest && Rating.where(:restaurant_id => rating_params[:restaurant_id], :customer_id => rating_params[:customer_id]).count == 0
            @rating = Rating.new(rating_params)
            @rating.save
        end
        redirect_to '/restaurant_page?rest_id=' + params[:restaurant_id].to_s
    end


  private
    def rating_params
        params.permit(:restaurant_id, :rating, :customer_id)
    end

end
