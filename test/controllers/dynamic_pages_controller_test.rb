require 'test_helper'

class DynamicPagesControllerTest < ActionController::TestCase
  setup do
    @user1 = User.create(name: "test1", email: "test1@gmail.com", password: "foobar11", password_confirmation: "foobar11",
          rest: false)
    @cust = Customer.create(user_id: @user1.id, phone_number: 00000)
    @user2 = User.new(id: 90, name: "Example User", email: "user@example.com",
                     password: "foobar123", password_confirmation: "foobar123", rest: true)
    @user2.save
    @restaurant = Restaurant.new("description"=>"123", "price"=>"1", "address"=>"123", "rest_type"=>"Italian", "zip" =>"94704", "city" =>"berkeley", "hours_attributes"=>{"0"=>{"open"=>"11:11", "close"=>"11:11", "rest_id"=>"90", "day_id"=>"1"}, "1"=>{"open"=>"14:22", "close"=>"14:22", "rest_id"=>"90", "day_id"=>"2"}, "2"=>{"open"=>"15:32", "close"=>"15:33", "rest_id"=>"90", "day_id"=>"3"}, "3"=>{"open"=>"03:22", "close"=>"15:32", "rest_id"=>"90", "day_id"=>"4"}, "4"=>{"open"=>"16:44", "close"=>"21:09", "rest_id"=>"90", "day_id"=>"5"}, "5"=>{"open"=>"18:06", "close"=>"19:07", "rest_id"=>"90", "day_id"=>"6"}, "6"=>{"open"=>"08:08", "close"=>"20:08", "rest_id"=>"90", "day_id"=>"7"}}, "user_id"=>"90")
    @restaurant.save

    # @user2 = User.new(id: 90, name: "test2", email: "test1@gmail.com", password: "foobar11", password_confirmation: "foobar11",
    #       rest: true)
    @user1.save
    # @user2.save
    @cust.save

  end
  

  test "profile" do
    get :profile
    assert_redirected_to sign_in_path
  end

  test "home" do
    get :home
    assert_redirected_to index_path
  end

  test "home customer" do
    sign_in @user1
    get :home
    assert_redirected_to profile_path
  end

  test "home restaurant with model" do
    sign_in @user2
    get :home
    assert_redirected_to profile_path
  end

  test "home restaurant without model" do
    @user3 = User.new(name: "Example User1", email: "user1@example.com",
                     password: "foobar1231", password_confirmation: "foobar1231", rest: true)
    @user3.save
    sign_in @user3
    get :home
    assert_redirected_to restaurant_new_path
  end

  test "index" do
    get :index
    assert_template "index"
  end

  test "signup" do
    get :signup
    assert_template "signup"
  end

  test "test restaurant" do
    i = 1
    while i < 8  do
      @hour = Hour.new(rest_id: 90, day_id: i, open: "10:00", close: "11:00")
      @hour.save
      i+=1
    end
    @hour = User.where(id: 90).first
    get :restaurant, rest_id: @restaurant.user_id
    assert_response :success
  end

  test "test restaurant close" do
    i = 1
    while i < 8  do
      @hour = Hour.new(rest_id: 90, day_id: i)
      @hour.save
      i+=1
    end
    @hour = User.where(id: 90).first
    get :restaurant, rest_id: @restaurant.user_id
    assert_response :success
  end

end
