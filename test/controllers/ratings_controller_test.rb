require 'test_helper'

class RatingControllerTest < ActionController::TestCase
  setup do
    @restaurant = Restaurant.new("description"=>"123", "price"=>"1", "address"=>"123", "rest_type"=>"Italian", "zip" =>"94704", "city" =>"berkeley", "hours_attributes"=>{"0"=>{"open"=>"11:11", "close"=>"11:11", "rest_id"=>"90", "day_id"=>"1"}, "1"=>{"open"=>"14:22", "close"=>"14:22", "rest_id"=>"90", "day_id"=>"2"}, "2"=>{"open"=>"15:32", "close"=>"15:33", "rest_id"=>"90", "day_id"=>"3"}, "3"=>{"open"=>"03:22", "close"=>"15:32", "rest_id"=>"90", "day_id"=>"4"}, "4"=>{"open"=>"16:44", "close"=>"21:09", "rest_id"=>"90", "day_id"=>"5"}, "5"=>{"open"=>"18:06", "close"=>"19:07", "rest_id"=>"90", "day_id"=>"6"}, "6"=>{"open"=>"08:08", "close"=>"20:08", "rest_id"=>"90", "day_id"=>"7"}}, "user_id"=>"90")
    assert @restaurant.save
    @customer = Customer.new(user_id:1, phone_number: 0000)
    @customer.save
    @user = User.create(id: 90, name: 'cust 1', email: 'FendyOnel@gmail.com', rest: false, password: '123123123', password_confirmation: '123123123')
    assert @user.save
    #@rating = Rating.new(customer_id:1, restaurant_id: 1, rating: 2)
    #@customer.save
#    @controller = RatingsController.new
  end

    # should create a new rating and redirect back
    test "should create rating" do
        assert sign_in @user
        assert_difference('Rating.count') do
            post :create, { restaurant_id: @restaurant.id, rating: 2, customer_id: @customer.id}
        end
        assert_not_nil Rating.where(customer_id: @customer.id,restaurant_id: @restaurant.id)
        assert_response :redirect
    end


end



























