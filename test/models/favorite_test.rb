require 'test_helper'

class FavoriteTest < ActiveSupport::TestCase
  def setup

    # create user as customer and populate into database
    @restaurant = Restaurant.new("description"=>"123", "price"=>"1", "address"=>"123", "rest_type"=>"Italian",  "zip" =>"94704", "city" =>"berkeley", "hours_attributes"=>{"0"=>{"open"=>"11:11", "close"=>"11:11", "rest_id"=>"90", "day_id"=>"1"}, "1"=>{"open"=>"14:22", "close"=>"14:22", "rest_id"=>"90", "day_id"=>"2"}, "2"=>{"open"=>"15:32", "close"=>"15:33", "rest_id"=>"90", "day_id"=>"3"}, "3"=>{"open"=>"03:22", "close"=>"15:32", "rest_id"=>"90", "day_id"=>"4"}, "4"=>{"open"=>"16:44", "close"=>"21:09", "rest_id"=>"90", "day_id"=>"5"}, "5"=>{"open"=>"18:06", "close"=>"19:07", "rest_id"=>"90", "day_id"=>"6"}, "6"=>{"open"=>"08:08", "close"=>"20:08", "rest_id"=>"90", "day_id"=>"7"}}, "user_id"=>"90")
    @restaurant2 = Restaurant.new("description"=>"124", "price"=>"1", "address"=>"123", "rest_type"=>"Italian",  "zip" =>"94704", "city" =>"berkeley1", "hours_attributes"=>{"0"=>{"open"=>"11:11", "close"=>"11:11", "rest_id"=>"90", "day_id"=>"1"}, "1"=>{"open"=>"14:22", "close"=>"14:22", "rest_id"=>"90", "day_id"=>"2"}, "2"=>{"open"=>"15:32", "close"=>"15:33", "rest_id"=>"90", "day_id"=>"3"}, "3"=>{"open"=>"03:22", "close"=>"15:32", "rest_id"=>"90", "day_id"=>"4"}, "4"=>{"open"=>"16:44", "close"=>"21:09", "rest_id"=>"90", "day_id"=>"5"}, "5"=>{"open"=>"18:06", "close"=>"19:07", "rest_id"=>"90", "day_id"=>"6"}, "6"=>{"open"=>"08:08", "close"=>"20:08", "rest_id"=>"90", "day_id"=>"7"}}, "user_id"=>"90")
    @user = User.new(id: 2, name: 'user 1', email: 'AtidJenad@gmail.com', rest: false, password: '123123123', password_confirmation: '123123123')
    @user.save
    @restaurant.save
    @restaurant2.save
    
    # create user as restaurant and populate into database
    @user_rest = User.create(name: "test2", email: "test2@gmail.com", password:"foobar12", password_confirmation: "foobar12",
            rest: true)
    @user_rest2 = User.create(name: "test1", email: "test1@gmail.com", password:"foobar13", password_confirmation: "foobar13",
            rest: true)
    @rest = Restaurant.create(user_id: @user_rest.id)
    @rest1 = Restaurant.create(user_id: @user_rest2.id)
    @user_rest.save
    @user_rest2.save
    @rest1.save
    @rest.save
  end

  test "Correct Favorite parameter" do
    @fav = Favorite.new(cust_id: @user.id, rest_id: @rest.user_id)
    status = @fav.save
    assert_equal(status, true)
  end
  
  test "no cust id" do
    @fav = Favorite.new(cust_id: "", rest_id: @rest.user_id)
    @fav.save
    # assert_equal(status, false)
  end

  test "no rest id" do
    @fav = Favorite.new(cust_id: 2, rest_id: "")
    status = @fav.save
    assert_equal(status, false)
  end

  # should be implemented in controller
  test "id rest_id is invalid" do

    @fav1 = Favorite.new(cust_id: 4, rest_id: 2)
    status = @fav1.check_params
    assert_equal(status, false)

    @fav2 = Favorite.new(cust_id: 3, rest_id: 2)
    status = @fav2.check_params
    assert_equal(status, false)
  end

  test "cust_id == rest_id able to waitlist more than once" do
    assert_difference('Favorite.count', 1) do 
        @fav = Favorite.new(cust_id: 1, rest_id: 1)
        status = @fav.check_params
        assert_equal(status, false)
        @fav.save
    end
    assert_difference('Favorite.count', 1) do 
        @fav = Favorite.new(cust_id: @user_rest.id, rest_id: @user_rest.id)
        status = @fav.check_params
        assert_equal(status, false)
        @fav.save
    end
    assert_difference('Favorite.count', 1) do 
        @fav = Favorite.new(cust_id: @user_rest.id, rest_id: @user_rest2.id)
        status = @fav.check_params
        assert_equal(status, false)
        @fav.save
    end
  end

  #same customer can't favorite on the same restaurant more than once
  test "unique customer to restaurant favorite" do
    @fav = Favorite.new(cust_id: @user.id, rest_id: @rest.user_id)
    status = @fav.check_params
    assert_equal(status, true)
    @fav.save
    @fav = Favorite.new(cust_id: @user.id, rest_id: @rest.user_id)
    status = @fav.check_params
    assert_equal(status, false)
  end
end
