require 'test_helper'

class RatingTest < ActiveSupport::TestCase
  def setup

    @restaurant = Restaurant.new(user_id: 1, address: '1893 Berkeley Avenue')
    @restaurant.save
    @user = User.new(id: 1, name: 'rest 1', email: 'FendyOnel@gmail.com', rest: true, password: '123123123', password_confirmation: '123123123')
    @user.save

    @customer = Customer.new(user_id:2, phone_number: 0000)
    @customer.save
    @user2 = User.new(id: 2, name: 'user 1', email: 'AtidJenad@gmail.com', rest: false, password: '123123123', password_confirmation: '123123123')
    @user2.save

  end

  test "correct rating parameter" do
    @list = Rating.new(customer_id: @user2.id, restaurant_id: @user.id, rating: 3)
    status = @list.save
    assert_equal(status, true)
  end

  test "correct average rating" do
      @list2 = Rating.new(customer_id: @user2.id, restaurant_id: @user.id, rating: 3)
      @list2.save
      avg = Rating.average_rating(@user.id)
      assert_equal(avg, 3)
  end

  test "correct empty rating" do
    avg = Rating.average_rating(@user.id)
    assert_equal(avg, 0)
  end

  test "rating exists" do
    @list2 = Rating.new(customer_id: @user2.id, restaurant_id: @user.id, rating: 3)
    @list2.save
    avg = Rating.rate_exist(@user.id,@user2.id)
    assert_equal(avg, true)
  end

  test "rating does not exists" do
    avg = Rating.rate_exist(@user.id,@user2.id)
    assert_equal(avg, false)
  end

    
end
