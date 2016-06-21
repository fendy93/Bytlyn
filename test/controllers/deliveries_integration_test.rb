require 'test_helper'

class DeliveriesRoutesTest < ActionDispatch::IntegrationTest
    setup do
        @restaurant = Restaurant.new(user_id: 1, address: '1893 Berkeley Avenue')
        @restaurant.save
        @user1 = User.new(id: 1, name: 'rest 1', email: 'FendyOnel@gmail.com', rest: true, password: '123123123', password_confirmation: '123123123')
        @user1.save

        @customer = Customer.new(user_id:2, phone_number: 0000)
        @customer.save
        @user2 = User.new(id: 2, name: 'user 1', email: 'AtidJenad@gmail.com', rest: false, password: '123123123', password_confirmation: '123123123')
        @user2.save

        @menu1 = Menu.new(id: 1, rest_id: 1, name: 'test1', price: 2.5)
        @menu1.save

        @menu2 = Menu.new(id: 2, rest_id: 1, name: 'test2', price: 3.5)
        @menu2.save

        @version = Version.new(id: 1, cust_id: 2, rest_id: 1, count: 0)
        @version.save

        @cart1 = Cart.new(cust_id:2, rest_id: 1, version: 0, menu_id: 1, qty: 1)
        @cart1.save

        @cart2 = Cart.new(cust_id:2, rest_id: 1, version: 0, menu_id: 2, qty: 1)
        @cart2.save

    end

    test "access index not signed in" do
        get '/delivery'
        assert_redirected_to login_path
    end

    test "access index customer" do
        post_via_redirect "/sign_in", 'user[email]' => @user2.email, 'user[password]' => @user2.password
        get '/delivery'
        assert_response :success
        assert_template "deliveries/cust_index.html.erb"
    end

    test "access index restaurant legal" do
        post_via_redirect "/sign_in", 'user[email]' => @user1.email, 'user[password]' => @user1.password
        get '/delivery'
        assert_response :success
        assert_template "deliveries/rest_index.html.erb"
    end

    test "access index restaurant not yet established" do
        get "/logout"
        @user3 = User.new(id: 3, name: 'rest 1', email: 'dy@gmail.com', rest: true, password: '123123123', password_confirmation: '123123123')
        @user3.save
        post_via_redirect "/sign_in", 'user[email]' => @user3.email, 'user[password]' => @user3.password
        get '/delivery'
        assert_redirected_to restaurant_new_path
    end

    test "access history not signed in" do
        get '/delivery_history'
        assert_redirected_to login_path
    end

    test "access history customer" do
        post_via_redirect "/sign_in", 'user[email]' => @user2.email, 'user[password]' => @user2.password
        get '/delivery_history'
        assert_response :success
        assert_template "deliveries/cust_index.html.erb"
    end

    test "access history restaurant legal" do
        post_via_redirect "/sign_in", 'user[email]' => @user1.email, 'user[password]' => @user1.password
        get '/delivery_history'
        assert_response :success
        assert_template "deliveries/rest_index.html.erb"
    end

    test "access history restaurant not yet established" do
        get "/logout"
        @user3 = User.new(id: 3, name: 'rest 1', email: 'dy@gmail.com', rest: true, password: '123123123', password_confirmation: '123123123')
        @user3.save
        post_via_redirect "/sign_in", 'user[email]' => @user3.email, 'user[password]' => @user3.password
        get '/delivery_history'
        assert_redirected_to restaurant_new_path
    end

    test "new delivery not signed in" do
        get "/logout"
        get '/delivery_new'
        assert_redirected_to login_path
    end

    test "new delivery signed in" do
        post_via_redirect "/sign_in", 'user[email]' => @user2.email, 'user[password]' => @user2.password
        get '/delivery_new', cart_id: [@cart1.id], rest_id: 1, total: 2.5
        assert_template :new
    end

    test "create delivery successfully and update status" do 
        get "/logout"
        assert_difference [ 'Delivery.count'], 1 do
            post_via_redirect "/sign_in", 'user[email]' => @user2.email, 'user[password]' => @user2.password
            post '/delivery_new', delivery: {phone: "123", rest_id: 1, version: 0, user_id: 2, address:"kali", total: 2.5}, payment_method_nonce: Braintree::Test::Nonce::Transactable  
        end

        assert_equal(Version.where(rest_id: 1, cust_id: 2).first.count,1)
        assert_equal(Delivery.where(rest_id: 1, user_id:2, version:0).first.status, 1)
        assert_equal(Version.where(rest_id: 1, cust_id: 2).first.count,1)
        assert_equal(Delivery.where(rest_id: 1, user_id:2, version:0).first.status, 1)

        post_via_redirect "/update_status", delivery: Delivery.where(rest_id: 1, user_id:2, version:0).first.id
        assert_equal(Delivery.where(rest_id: 1, user_id:2, version:0).first.status, 2)

        post_via_redirect "/update_status", delivery: Delivery.where(rest_id: 1, user_id:2, version:0).first.id
        assert_equal(Delivery.where(rest_id: 1, user_id:2, version:0).first.status, 3)

        # assert_difference [ 'Delivery.count'], -1 do
        #     path = 'deliveries/'
        #     path << Delivery.where(rest_id: 1, user_id:2, version:0).first.id.to_s
        #     delete path
        # end
    end



    test "create delivery not valid credit card" do 
        get "/logout"
        assert_no_difference [ 'Delivery.count'] do
            post_via_redirect "/sign_in", 'user[email]' => @user2.email, 'user[password]' => @user2.password
            post '/delivery_new', delivery: {phone: "123", rest_id: 1, version: 0, user_id: 2, address:"kali", total: 2.5}, payment_method_nonce: Braintree::Test::Nonce::Consumed 
        end
        assert_redirected_to profile_path
    end

    test "create delivery not signed in " do
        get "/logout"
        assert_no_difference [ 'Delivery.count'] do
             post '/delivery_new', delivery: {phone: "123", rest_id: 1, version: 0, user_id: 2, address:"kali", total: 2.5}, payment_method_nonce: Braintree::Test::Nonce::Transactable 
        end
        assert_redirected_to login_path
    end
   


end


