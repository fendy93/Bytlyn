require 'test_helper'

class MenusControllerTest < ActionController::TestCase
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

    # create sign in session
    sign_in @user2

    # create menu
    @menu = Menu.new(rest_id: @rest.user_id, name: 'test', description: 'test', price: 1)
    assert @menu.save
  end

  # should render 'rest.html.erb'(redirect to menus page)
  test "should get index" do
    get :index
    assert_response :success
    assert_generates "/menus", controller: "menus"
  end

  # should redirect to login path since customer is signed in
  test "should not get index" do
    sign_out @user2
    sign_in @user1
    get :index
    assert_redirected_to login_path
  end

  # should redirected to new menus path
  test "should get new" do
    get :new
    assert_response :success
  end

  # should redirected to login path since user is not restaurant
  test "should not get new" do
    sign_out @user2
    sign_in @user1
    get :new
    assert_redirected_to login_path
  end

  # should create a new menu and redirect to menus_path
  test "should create menu" do
    assert_difference('Menu.count') do
      post :create, menu: { description: @menu.description, name: @menu.name, price: @menu.price, rest_id: @menu.rest_id }
    end
    assert Menu.where(name: @menu.name).first == @menu
    assert_redirected_to menus_path
  end

  # should redirect to menus_edit path for menu with the specific id
  test "should get edit" do
    get :edit, id: @menu
    assert_response :success
  end

  # should redirect to profile path since there is no menu_id
  test "should not get edit test1" do
    get :edit
    assert_redirected_to login_path
  end

  # should redirect to profile path since the user is not restaurant
  test "should not get edit test2" do
    sign_out @user2
    sign_in @user1
    get :edit, id: @menu
    assert_redirected_to login_path
  end

  # should successfully update the menu
  test "should update menu" do
    menu1 = Menu.find(@menu.id)
    patch :update, id: @menu, menu: { description: @menu.description, name: '@menu.name', price: @menu.price, rest_id: @menu.rest_id }
    menu2 = Menu.find(@menu.id)
    assert_not_equal(menu1.name, menu2.name)
    assert_redirected_to menus_path
  end

  # should successfuly destroy the menu since the user is a restaurant
  test "should destroy menu" do
    assert_difference('Menu.count', -1) do
      delete :destroy, id: @menu
    end
    assert_redirected_to menus_path
  end



end
