require 'test_helper'

class CartTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  setup do
    @restaurant = Restaurant.new(user_id: 1, address: '1893 Berkeley Avenue')
    @restaurant.save
    @user = User.new(id: 1, name: 'rest 1', email: 'FendyOnel@gmail.com', rest: true, password: '123123123', password_confirmation: '123123123')
    @user.save

    @customer = Customer.new(user_id:2, phone_number: 0000)
    @customer.save
    @user = User.new(id: 2, name: 'user 1', email: 'AtidJenad@gmail.com', rest: false, password: '123123123', password_confirmation: '123123123')
    @user.save

    @menu1 = Menu.new(id: 1, rest_id: 1, name: 'test1', price: 2.5)
    @menu1.save

    @menu2 = Menu.new(id: 2, rest_id: 1, name: 'test2', price: 3.5)
    @menu2.save

    @version = Version.new(id: 1, cust_id: 2, rest_id: 1, count: 0)
    @version.save

  end

  test "current cart test" do 
    @cart1 = Cart.new(cust_id:2, rest_id: 1, version: 0, menu_id: 1, qty: 1)
    @cart1.save

    @cart2 = Cart.new(cust_id:2, rest_id: 1, version: 0, menu_id: 2, qty: 1)
    @cart2.save

    curCart = Cart.current_cart(2)
    assert_equal(6, curCart[:cart][1])
  end

  test "find cart test" do
    @cart = Cart.new(id: 1, cust_id:2, rest_id: 1, version: 0, menu_id: 1, qty: 1)
    @cart.save
    cartFound = Cart.find_cart(2, 1, 0).first
    assert_equal(cartFound, @cart)
  end

  # def test_user_id
  #   cust = Customer.new :user_id => "", :phone_number => 00000              
  #   assert_false cust.save

  #   cust = @customer.dup
  #   assert_false cust.save
  # end
end