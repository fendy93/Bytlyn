class DynamicPagesController < ApplicationController
    before_action :authenticate_user!, except: [:restaurant,:index, :show, :login, :signup, :signup_rest, :signup_user, :home, :team, :termscondition, :privacy, :career]

    def profile
        if user_signed_in?
            if current_user.rest 
                if Restaurant.find_by_user_id(current_user.id) != nil
                    render "profile-resto.html.erb"
                else
                    redirect_to restaurant_new_path
                end

            else
                render "profile.html.erb"
            end
        else
            redirect_to sign_in_path
        end 
    end

    def index
    end

    def signup
    end

    def termscondition
        render "termscondition.html"
    end

    def privacy
        render "privacy.html"
    end

    def career
        render "career.html" 
    end

    def home
        if user_signed_in?
            if current_user.rest && Restaurant.find_by_user_id(current_user.id) == nil
                redirect_to restaurant_new_path
            else
            redirect_to profile_path
            end 
        else
            redirect_to index_path
        end
    end
    def restaurant_delivery
        render "restaurant-delivery.html.erb"
    end

    def restaurant
        # if user_signed_in?
        @hour = Hour.where(rest_id: params[:rest_id])
        @monday = @hour.where(day_id: 1)
        @monday = @monday.first
        if (@monday.open != nil && @monday.open != nil)
            
            @monday_time = @monday.open.strftime('%H:%M') + " - " + @monday.close.strftime('%H:%M') 

        else 
            @monday_time = 'closed'
        end
        @tuesday = @hour.where(day_id: 2)
        @tuesday = @tuesday.first
        if (@tuesday.open != nil && @tuesday.open != nil)
            
            @tuesday_time = @tuesday.open.strftime('%H:%M') + " - " + @tuesday.close.strftime('%H:%M') 

        else 
            @tuesday_time = 'closed'
        end
        @wednesday = @hour.where(day_id: 3)
        @wednesday = @wednesday.first
        if (@wednesday.open != nil && @wednesday.open!= nil)
            
            @wednesday_time = @wednesday.open.strftime('%H:%M') + " - " + @wednesday.close.strftime('%H:%M') 

        else 
            @wednesday_time = 'closed'
        end
        @thursday = @hour.where(day_id: 4)
        @thursday = @thursday.first
        if (@thursday.open != nil && @thursday.open != nil)
            
            @thursday_time = @thursday.open.strftime('%H:%M') + " - " + @thursday.close.strftime('%H:%M') 

        else 
            @thursday_time = 'closed'
        end
        @friday = @hour.where(day_id: 5)
        @friday = @friday.first
        if (@friday.open != nil && @friday.open!= nil)
            
            @friday_time = @friday.open.strftime('%H:%M') + " - " + @friday.close.strftime('%H:%M') 

        else 
            @friday_time = 'closed'
        end
        @saturday = @hour.where(day_id: 6)
        @saturday = @saturday.first
        if (@saturday.open != nil && @saturday.close != nil)
            
            @saturday_time = @saturday.open.strftime('%H:%M') + " - " + @saturday.close.strftime('%H:%M') 

        else 
            @saturday_time = 'closed'
        end
        @sunday = @hour.where(day_id: 7)
        @sunday = @sunday.first
        if (@sunday.open != nil && @sunday.close != nil)
            
            @sunday_time = @sunday.open.strftime('%H:%M') + " - " + @sunday.close.strftime('%H:%M') 

        else 
            @sunday_time = 'closed'
        end

        @rate = Rating.average_rating(params[:rest_id])

        render "restaurant.html.erb"
    end

end
