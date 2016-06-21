require 'test_helper'

class CustomersControllerTest < ActionController::TestCase
  setup do
    @customer = Customer.new(user_id:2, phone_number: 0000)
    @customer.save
    @user = User.new(id: 2, name: 'user 1', email: 'AtidJenad@gmail.com', rest: false, password: '123123123', password_confirmation: '123123123')
    @user.save
    
    
  end


  test "should create customer" do
    assert_difference('Customer.count') do
        post :create, customer: { user_id: "10", phone_number: 00000 }
    end
    assert_redirected_to customer_path(assigns(:customer))
  end

  test "should show customer" do
    get :show, id: @customer
    assert_response :success
  end

  test "should get edit customer" do
    assert_no_difference('Customer.count') do
      get :edit, id: @customer
    end
    assert_response :success
  end

  test "should update customer" do
    assert_no_difference('Customer.count') do
      patch :update, id: @customer, customer: { user_id: "10", phone_number: 00000 }
    end
    assert_redirected_to customer_path(assigns(:customer))
  end

  test "should destroy customer" do
    assert_difference('Customer.count', -1) do
      delete :destroy, id: @customer
    end
    assert_redirected_to customers_path
  end



end
