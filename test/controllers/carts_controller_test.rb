require 'test_helper'

class CartsControllerTest < ActionController::TestCase
  setup do
    # create user as customer and populate into database
    @user1 = User.create(name: "test1", email: "test1@gmail.com", password: "foobar11", password_confirmation: "foobar11",
          rest: false)
    @cust = Customer.create(user_id: @user1.id, phone_number: 00000)
    @user1.save
    @cust.save
    
    # create user as restaurant and populate into database
    @user2 = User.create(name: "test2", email: "test2@gmail.com", password:"foobar12", password_confirmation: "foobar12",
            rest: true)
    @rest = Restaurant.create(user_id: @user2.id)
    @user2.save
    @rest.save

    # create user as customer and populate into database
    @user3 = User.create(name: "test3", email: "test3@gmail.com", password: "foobar13", password_confirmation: "foobar13",
          rest: false)
    @cust2 = Customer.create(user_id: @user3.id, phone_number: 00000)
    @user3.save
    @cust2.save

    # create sign in session
    sign_in @user1

    # create version
    @version = Version.new(rest_id: @rest.user_id, cust_id: @cust.user_id, count: 0)
    assert @version.save

    # create menu
    @menu = Menu.new(rest_id: @rest.user_id, name: 'test', description: 'test', price: 1)
    assert @menu.save

  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cart with existing version" do
    @request.env['HTTP_REFERER'] = 'http://localhost:3000/restaurant_page'
    assert_difference('Cart.count') do
      post :create, cart: { rest_id: @rest.user_id, cust_id: @cust.user_id, menu_id: @menu.id }
    end
    assert_not_nil(Cart.where(cust_id: @cust.user_id).first)
  end

  test "should create cart without existing version" do
    @request.env['HTTP_REFERER'] = 'http://localhost:3000/restaurant_page'
    assert_difference('Cart.count') do
      post :create, cart: { rest_id: @rest.user_id, cust_id: @cust2.user_id, menu_id: @menu.id }
    end
    assert_not_nil(Cart.where(cust_id: @cust2.user_id).first)
  end

  test "should create cart with quantity 2" do
    @request.env['HTTP_REFERER'] = 'http://localhost:3000/restaurant_page'
    @cart = Cart.new(rest_id: @rest.user_id, cust_id: @cust.user_id, menu_id: @menu.id ,version: 0, qty: 1)
    assert @cart.save
    assert_no_difference('Cart.count') do
      post :create, cart: { rest_id: @rest.user_id, cust_id: @cust.user_id, menu_id: @menu.id, version: 0}
    end
    assert_equal(2, Cart.find(@cart.id).qty)
  end

  test "should update cart" do
    @cart = Cart.new(rest_id: @rest.user_id, cust_id: @cust.user_id, menu_id: @menu.id ,version: 0, qty: 1)
    assert @cart.save
    cart = Cart.find(@cart.id)
    patch :update, id: @cart.id, cart: {rest_id: @rest.user_id, cust_id: @cust.user_id, menu_id: @menu.id, version: 1, qty: 1}
    cartRet = Cart.find(@cart.id)
    assert_not_equal(cart.version, cartRet.version)
  end

  test "should destroy cart" do
    @cart = Cart.new(rest_id: @rest.user_id, cust_id: @cust.user_id, menu_id: @menu.id ,version: 0, qty: 1)
    assert @cart.save
    assert_difference('Cart.count', -1) do
      delete :destroy, id: @cart
    end
  end

  test "should clear cart" do
    @request.env['HTTP_REFERER'] = 'http://localhost:3000/restaurant_page'
    @cart = Cart.new(rest_id: @rest.user_id, cust_id: @cust.user_id, menu_id: @menu.id ,version: 0, qty: 1)
    assert @cart.save
    assert_difference('Cart.count', -1) do
      post :clear, id: @cart, rest_id: @rest.user_id, cust_id: @cust.user_id, menu_id: @menu.id ,version: 0, qty: 1
    end
  end

  test "should not clear cart" do
    sign_out @user1
    @cart = Cart.new(rest_id: @rest.user_id, cust_id: @cust.user_id, menu_id: @menu.id ,version: 0, qty: 1)
    assert @cart.save
    assert_no_difference('Cart.count', -1) do
      post :clear, id: @cart, rest_id: @rest.user_id, cust_id: @cust.user_id, menu_id: @menu.id ,version: 0, qty: 1
    end
    assert_redirected_to login_path
  end

end
