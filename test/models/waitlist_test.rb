require 'test_helper'

class WaitlistTest < ActiveSupport::TestCase
  def setup

    @restaurant = Restaurant.new(user_id: 1, address: '1893 Berkeley Avenue')
    @restaurant.save
    @user = User.new(id: 1, name: 'rest 1', email: 'FendyOnel@gmail.com', rest: true, password: '123123123', password_confirmation: '123123123')
    @user.save

    @customer = Customer.new(user_id:2, phone_number: 0000)
    @customer.save
    @user = User.new(id: 2, name: 'user 1', email: 'AtidJenad@gmail.com', rest: false, password: '123123123', password_confirmation: '123123123')
    @user.save

    @restaurant = Restaurant.new(user_id: 3, address: '1893 Berkeley Avenue')
    @restaurant.save
    @user = User.new(id: 3, name: 'rest 2', email: 'FendyOnel2@gmail.com', rest: true, password: '123123123', password_confirmation: '123123123')
    @user.save

    @customer = Customer.new(user_id:4, phone_number: 0000)
    @customer.save
    @user = User.new(id: 4, name: 'user 2', email: 'AtidJenad2@gmail.com', rest: false, password: '123123123', password_confirmation: '123123123')
    @user.save
  end

  test "Correct Waitlist parameter" do
    @list = Waitlist.new(cust_id: 2, rest_id: 1, people: 3, status: 1)
    status = @list.save
    assert_equal(status, true)
  end
  
  test "Correct Waitlist parameter name" do
    @list = Waitlist.new(cust_id: 2, rest_id: 1, people: 3, name: "jessica",status: 1)
    status = @list.save
    assert_equal(status, true)
  end


  test "no cust id" do
    @list = Waitlist.new(cust_id: "", rest_id: 1, people: 3,status: 1)
    @list.save
    # assert_equal(status, false)
  end
  test "no rest id" do
    @list = Waitlist.new(cust_id: 2, rest_id: "", people: 3,status: 1)
    status = @list.save
    assert_equal(status, false)
  end

  test "no people" do
    @list = Waitlist.new(cust_id: 2, rest_id: 1, people: "",status: 1)
    status = @list.save
    assert_equal(status, false)
  end

  # should be implemented in controller
  test "id rest_id is invalid" do

    @list = Waitlist.new(cust_id: 4, rest_id: 2, people: 3,status: 1)
    status = @list.check_params
    assert_equal(status, false)

    @list = Waitlist.new(cust_id: 3, rest_id: 2, people: 3,status: 1)
    status = @list.check_params
    assert_equal(status, false)
  end

  test "id cust_id is invalid" do #restaurant can't waitlist on other restaurant
    @list = Waitlist.new(cust_id: 2, rest_id: 1, people: 3,status: 1)
    status = @list.check_params
    assert_equal(status, true)
  end

  test "cust_id == rest_id able to waitlist more than once" do
    assert_difference('Waitlist.count', 1) do 
        @list = Waitlist.new(cust_id: 1, rest_id: 1, people: 3,status: 1)
        status = @list.check_params
        assert_equal(status, true)
        @list.save
    end
    assert_difference('Waitlist.count', 1) do 
        @list = Waitlist.new(cust_id: 1, rest_id: 1, people: 4,status: 1)
        status = @list.check_params
        assert_equal(status, true)
        @list.save
    end
  end

  #same customer can't waitlist on the same restaurant more than once
  test "unique customer to restaurant waitlist" do
    @list = Waitlist.new(cust_id: 2, rest_id: 1, people: 3,status: 1)
    status = @list.check_params
    assert_equal(status, true)
    @list.save
    @list = Waitlist.new(cust_id: 2, rest_id: 1, people: 3,status: 1)
    status = @list.check_params
    assert_equal(status, false)

  end

  test "position simple" do
    @list1 = Waitlist.new(cust_id: 2, rest_id: 1, people: 3,status: 1)
    status = @list1.check_params
    assert_equal(status, true)
    @list1.save

    @list2 = Waitlist.new(cust_id: 4, rest_id: 1, people: 3,status: 1)
    status = @list2.check_params
    assert_equal(status, true)
    @list2.save

    assert_equal([{:list => @list1, :position => 1}], Waitlist.get_customer_waitlist(2))
    assert_equal([{:list => @list2, :position => 2}], Waitlist.get_customer_waitlist(4))
    assert_equal([@list1, @list2], Waitlist.get_restaurant_waitlist(1))
  end

  test "position if deleted 1st place" do
    @list1 = Waitlist.new(cust_id: 2, rest_id: 1, people: 3,status: 1)
    status = @list1.check_params
    assert_equal(status, true)
    @list1.save

    @list2 = Waitlist.new(cust_id: 4, rest_id: 1, people: 3,status: 1)
    status = @list2.check_params
    assert_equal(status, true)
    @list2.save

    assert_equal([{:list => @list1, :position => 1}], Waitlist.get_customer_waitlist(2))
    assert_equal([{:list => @list2, :position => 2}], Waitlist.get_customer_waitlist(4))
    assert_equal([@list1, @list2], Waitlist.get_restaurant_waitlist(1))

    Waitlist.destroy(@list1.id)
    assert_equal([], Waitlist.get_customer_waitlist(2))
    assert_equal([{:list => @list2, :position => 1}], Waitlist.get_customer_waitlist(4))
    assert_equal([@list2], Waitlist.get_restaurant_waitlist(1))
  end

  test "position if deleted 2nd place" do
    @list1 = Waitlist.new(cust_id: 2, rest_id: 1, people: 3,status: 1)
    status = @list1.check_params
    assert_equal(status, true)
    @list1.save

    @list2 = Waitlist.new(cust_id: 4, rest_id: 1, people: 3,status: 1)
    status = @list2.check_params
    assert_equal(status, true)
    @list2.save

    assert_equal([{:list => @list1, :position => 1}], Waitlist.get_customer_waitlist(2))
    assert_equal([{:list => @list2, :position => 2}], Waitlist.get_customer_waitlist(4))
    assert_equal([@list1, @list2], Waitlist.get_restaurant_waitlist(1))

    Waitlist.destroy(@list2.id)
    assert_equal([{:list => @list1, :position => 1}], Waitlist.get_customer_waitlist(2))
    assert_equal([], Waitlist.get_customer_waitlist(4))
    assert_equal([@list1], Waitlist.get_restaurant_waitlist(1))
  end

  test "position in 2 restaurants" do
    @list1 = Waitlist.new(cust_id: 2, rest_id: 1, people: 3,status: 1)
    status = @list1.check_params
    assert_equal(status, true)
    @list1.save

    @list2 = Waitlist.new(cust_id: 4, rest_id: 1, people: 3,status: 1)
    status = @list2.check_params
    assert_equal(status, true)
    @list2.save

    @list3 = Waitlist.new(cust_id: 4, rest_id: 3, people: 3,status: 1)
    status = @list3.check_params
    assert_equal(status, true)
    @list3.save

    @list4 = Waitlist.new(cust_id: 2, rest_id: 3, people: 3,status: 1)
    status = @list4.check_params
    assert_equal(status, true)
    @list4.save

    assert_equal([{:list => @list1, :position => 1}, {:list => @list4, :position => 2}], Waitlist.get_customer_waitlist(2))
    assert_equal([{:list => @list2, :position => 2}, {:list => @list3, :position => 1}], Waitlist.get_customer_waitlist(4))
    assert_equal([@list1, @list2], Waitlist.get_restaurant_waitlist(1))
    assert_equal([@list3, @list4], Waitlist.get_restaurant_waitlist(3))
  end

  test "delete position in 2 restaurants" do
    @list1 = Waitlist.new(cust_id: 2, rest_id: 1, people: 3,status: 1)
    status = @list1.check_params
    assert_equal(status, true)
    @list1.save

    @list2 = Waitlist.new(cust_id: 4, rest_id: 1, people: 3,status: 1)
    status = @list2.check_params
    assert_equal(status, true)
    @list2.save

    @list3 = Waitlist.new(cust_id: 4, rest_id: 3, people: 3,status: 1)
    status = @list3.check_params
    assert_equal(status, true)
    @list3.save

    @list4 = Waitlist.new(cust_id: 2, rest_id: 3, people: 3,status: 1)
    status = @list4.check_params
    assert_equal(status, true)
    @list4.save

    assert_equal([{:list => @list1, :position => 1}, {:list => @list4, :position => 2}], Waitlist.get_customer_waitlist(2))
    assert_equal([{:list => @list2, :position => 2}, {:list => @list3, :position => 1}], Waitlist.get_customer_waitlist(4))
    assert_equal([@list1, @list2], Waitlist.get_restaurant_waitlist(1))
    assert_equal([@list3, @list4], Waitlist.get_restaurant_waitlist(3))

    Waitlist.destroy(@list1.id)
    assert_equal([{:list => @list4, :position => 2}], Waitlist.get_customer_waitlist(2))
    assert_equal([{:list => @list2, :position => 1}, {:list => @list3, :position => 1}], Waitlist.get_customer_waitlist(4))
    assert_equal([@list2], Waitlist.get_restaurant_waitlist(1))
    assert_equal([@list3, @list4], Waitlist.get_restaurant_waitlist(3))

    Waitlist.destroy(@list3.id)
    assert_equal([{:list => @list4, :position => 1}], Waitlist.get_customer_waitlist(2))
    assert_equal([{:list => @list2, :position => 1}], Waitlist.get_customer_waitlist(4))
    assert_equal([@list2], Waitlist.get_restaurant_waitlist(1))
    assert_equal([@list4], Waitlist.get_restaurant_waitlist(3))
  end

  test "history not show up in get waitlist" do
    @list1 = Waitlist.new(cust_id: 2, rest_id: 1, people: 3,status: 1)
    status = @list1.check_params
    assert_equal(status, true)
    @list1.save

    @list2 = Waitlist.new(cust_id: 2, rest_id: 3, people: 3,status: 2)
    status = @list2.check_params
    assert_equal(status, true)
    @list2.save

    @list3 = Waitlist.new(cust_id: 4, rest_id: 1, people: 3,status: 3)
    status = @list3.check_params
    assert_equal(status, true)
    @list3.save

    assert_equal([{:list => @list1, :position => 1}], Waitlist.get_customer_waitlist(2))
    assert_equal([@list1], Waitlist.get_restaurant_waitlist(1))
   end

   test "history customer" do
    @list1 = Waitlist.new(cust_id: 2, rest_id: 1, people: 3,status: 1)
    status = @list1.check_params
    assert_equal(status, true)
    @list1.save

    @list2 = Waitlist.new(cust_id: 2, rest_id: 3, people: 3,status: 2)
    status = @list2.check_params
    assert_equal(status, true)
    @list2.save

    @list3 = Waitlist.new(cust_id: 4, rest_id: 1, people: 3,status: 3)
    status = @list3.check_params
    assert_equal(status, true)
    @list3.save

    assert_equal([{:list => @list2, :position => nil}], Waitlist.get_customer_waitlist_history(2))
    assert_equal([@list3], Waitlist.get_restaurant_waitlist_history(1))
   end

   test "status string" do
    assert_equal("On Waitlist", Waitlist.status_string(1))
    assert_equal("Got In", Waitlist.status_string(2))
    assert_equal("No Show", Waitlist.status_string(3))
    assert_equal("Unknown", Waitlist.status_string(4))
end
    
end
