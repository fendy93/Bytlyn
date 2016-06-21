require 'test_helper'

class MenuTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "successful new menu" do
    @menu = Menu.new(rest_id:1, name: "test", description: "desc test", price: 10)
    assert @menu.save
  end
  
  test "not successful no rest id" do
    @menu = Menu.new(name: "test", description: "desc test", price: 10)
    assert_equal(@menu.save, false)
  end

  test "not successful no name" do
    @menu = Menu.new(rest_id:1, description: "desc test", price: 10)
    assert_equal(@menu.save, false)
  end

  test "not successful no price" do
    @menu = Menu.new(rest_id:1, description: "desc test", name: "test")
    assert_equal(@menu.save, false)
  end

  test "successful no description" do
    @menu = Menu.new(rest_id:1, name: "desc test", price: 10)
    assert @menu.save
  end

  test "successful get correct restaurant menu" do
    @menu = Menu.new(rest_id:1, name: "desc", price: 10)
    assert @menu.save
    @resp = Menu.get_restaurant_menu(1)
    assert_equal(@resp.first, @menu)
  end

  test "not successful get restaurant menu 1" do
    @menu = Menu.new(rest_id:2, name: "desc test", price: 10)
    assert @menu.save
    @resp = Menu.get_restaurant_menu(10)
    assert_not_equal(@resp, @menu)
  end

  test "not successful get restaurant menu 2" do
  	@customer = Customer.new(user_id:2, phone_number: 0000)
    @menu = Menu.new(rest_id:3, name: "desc test 2", price: 10)
    assert @menu.save
    @resp = Menu.get_restaurant_menu(@customer.user_id)
    assert_equal(@resp, false)
  end

end
