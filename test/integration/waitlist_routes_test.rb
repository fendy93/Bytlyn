require 'test_helper'

class WaitlistRoutesTest < ActionDispatch::IntegrationTest
	
	# initial setup
  	def setup
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

		@user3 = User.create(name: "test4", email: "test4@gmail.com", password:"foobar12", password_confirmation: "foobar12",
		  			rest: true)
		@user3.save
		# create sign in session
		post_via_redirect "/sign_in", 'user[email]' => @user1.email, 'user[password]' => @user1.password
	end

	# user can access waitlist page after sign in
	test "user can waitlist after sign in" do
	  	get waitlists_new_path	
	  	assert_response :success
	end

	# before sign in, user cannot access the waitlist page
	# they are instead redirected to login page
	test "user unable to waitlist before sign in" do
	  	delete destroy_user_session_path
	  	get waitlists_new_path
	  	assert_redirected_to login_path
	end

	# customer successfully waitlisted
	test "customer waitlist success" do
		post '/waitlists_new', waitlist: {cust_id: @cust.user_id, people: 5, rest_id: @rest.user_id}
	  	assert_not_nil Waitlist.where(cust_id: @cust.user_id).first
	end

	# customer cannot waitlist in the same restaurant at the same time multiple times
	test "customer waitlist fail" do
		# put waitlist
		post '/waitlists', waitlist: {cust_id: @cust.user_id, people: 5, rest_id: @rest.user_id}

		# put waitlist the second time and check that it is not saved into database
		assert_no_difference 'Waitlist.count' do
  			post '/waitlists', waitlist: {cust_id: @cust.user_id, people: 10, rest_id: @rest.user_id}
		end
	end

	# customer can waitlist in 2 different restaurants at the same time
	test "customer waitlist multiple rests success" do
		# creating temporary user as restaurant
		@user_tmp = User.create(name: "test3", email: "test3@gmail.com", password:"foobar13", password_confirmation: "foobar13",
		  			rest: true)
		@rest_tmp = Restaurant.create(user_id: @user_tmp.id)
		@user_tmp.save
		@rest_tmp.save

		# put waitlist in 2 different restaurants and check the database
		post '/waitlists', waitlist: {cust_id: @cust.user_id, people: 5, rest_id: @rest.user_id}
		post '/waitlists', waitlist: {cust_id: @cust.user_id, people: 5, rest_id: @rest_tmp.user_id}
		assert Waitlist.where(cust_id: @cust.user_id).size == 2
	end

	# customer can delete their waitlist
	test "customer delete waitlist success" do
		# post a waitlist
		post '/waitlists', waitlist: {people: 5, rest_id: @rest.user_id}
		@waitlist = Waitlist.where(cust_id: @cust.user_id).first
		assert_not_nil @waitlist

		# delete that specific waitlist and check in the database that it is deleted
		delete '/waitlists/' + @waitlist.id.to_s
		assert_nil Waitlist.where(cust_id: @cust.id).first
	end

	# restaurant can put waitlist to their own system
	test "restaurant put waitlist success" do
		# sign out from customer session and sign in to restaurant session
		delete destroy_user_session_path
		post_via_redirect "/sign_in", 'user[email]' => @user2.email, 'user[password]' => @user2.password

		# put waitlist to their own system and check
		post '/waitlists', waitlist: {people: 5, rest_id: @rest.user_id}
		assert_not_nil Waitlist.where(cust_id: @rest.user_id).first
	end

	# restaurant can put waitlist to their own system multiple times
	test "restaurant put multiple waitlist success" do
		# sign out from customer session and sign in to restaurant session
		delete destroy_user_session_path
		post_via_redirect "/sign_in", 'user[email]' => @user2.email, 'user[password]' => @user2.password

		# post waitlist multiple times and check
		post '/waitlists', waitlist: {people: 5, rest_id: @rest.user_id}
		post '/waitlists', waitlist: {people: 10, rest_id: @rest.user_id}
		assert Waitlist.where(cust_id: @rest.user_id).size == 2
	end

	# restaurant cannot waitlist to other restaurant
	test "restaurant put waitlist fail" do
		# creating temporary user as restaurant
		@user_tmp = User.create(name: "test3", email: "test3@gmail.com", password:"foobar13", password_confirmation: "foobar13",
		  			rest: true)
		@rest_tmp = Restaurant.create(user_id: @user_tmp.id)
		@user_tmp.save
		@rest_tmp.save

		delete destroy_user_session_path
		post_via_redirect "/sign_in", 'user[email]' => @user2.email, 'user[password]' => @user2.password
		post '/waitlists', waitlist: {people: 5, rest_id: @rest_tmp.user_id}
		assert_nil Waitlist.where(cust_id: @user2.id).first
	end

	# restaurant can delete waitlist in their own system
	test "restaurant delete waitlist success" do
		# sign out from customer session and sign in to restaurant session
		delete destroy_user_session_path
		post_via_redirect "/sign_in", 'user[email]' => @user2.email, 'user[password]' => @user2.password
		
		# post a waitlist into their system
		post '/waitlists', waitlist: {people: 5, rest_id: @rest.user_id}
		@waitlist = Waitlist.where(cust_id: @user2.id).first
		assert_not_nil @waitlist

		# delete that specific waitlist and check in the database that it is deleted
		delete '/waitlists/' + @waitlist.id.to_s
		assert_nil Waitlist.where(cust_id: @user2.id).first
	end

	test "waitlist customer" do
		post_via_redirect "/sign_in", 'user[email]' => @user1.email, 'user[password]' => @user1.password
        # assert_response :success
        get waitlists_path
        assert_response :success
        # assert response :success
	end

	test "waitlist restaurant" do
		get logout_path
		post_via_redirect "/sign_in", 'user[email]' => @user2.email, 'user[password]' => @user2.password
        # assert_response :success
        get waitlists_path
        assert_response :success
	end
	test "history not signed in" do
		get logout_path
		get waitlist_history_path

		assert_redirected_to login_path
	end

	test "history signed in" do
		post_via_redirect "/sign_in", 'user[email]' => @user2.email, 'user[password]' => @user2.password
		get waitlist_history_path
		assert_response :success
	end

	test "history signed in cust" do
		post_via_redirect "/sign_in", 'user[email]' => @user1.email, 'user[password]' => @user1.password
		get waitlist_history_path
		assert_response :success
	end

	test "history restaurant" do
		get logout_path
		post_via_redirect "/sign_in", 'user[email]' => @user2.email, 'user[password]' => @user2.password
		get waitlist_history_path
		
		assert_response :success
	end


	test "waitlist invalid" do 
		post '/waitlists_new', waitlist: {cust_id: @cust.user_id, rest_id: @rest.user_id}
		path = "/waitlists_new?rest_id="
		path << @rest.user_id.to_s
		assert_redirected_to path
	end

	test "update status success" do
		post_via_redirect "/sign_in", 'user[email]' => @user2.email, 'user[password]' => @user2.password
		post '/waitlists', waitlist: {cust_id: @cust.user_id, people: 5, rest_id: @rest.user_id}
		id = Waitlist.where(cust_id: @cust.user_id, rest_id: @rest.user_id).first.id
		post '/update_status_success', waitlist: id

		assert_equal(2, Waitlist.where(cust_id: @cust.user_id, rest_id: @rest.user_id).first.status)
	end

	test "update status no show" do
		post_via_redirect "/sign_in", 'user[email]' => @user2.email, 'user[password]' => @user2.password
		post '/waitlists', waitlist: {cust_id: @cust.user_id, people: 5, rest_id: @rest.user_id}
		id = Waitlist.where(cust_id: @cust.user_id, rest_id: @rest.user_id).first.id
		post '/update_status_no_show', waitlist: id

		assert_equal(3, Waitlist.where(cust_id: @cust.user_id, rest_id: @rest.user_id).first.status)
	end

	test "user stuck restaurant new path" do
		get logout_path
		post_via_redirect "/sign_in", 'user[email]' => @user3.email, 'user[password]' => @user3.password
		
		get "/waitlists"
		assert_redirected_to restaurant_new_path
		get "/waitlist_history"
		assert_redirected_to restaurant_new_path

	end

end
