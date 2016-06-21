require 'test_helper'

class FavoriteRoutesTest < ActionDispatch::IntegrationTest
	
	# initial setup
	def setup

    # create user as customer and populate into database
    @restaurant = Restaurant.new("description"=>"123", "price"=>"1", "address"=>"123", "rest_type"=>"Italian", "zip" =>"94704", "city" =>"berkeley", "hours_attributes"=>{"0"=>{"open"=>"11:11", "close"=>"11:11", "rest_id"=>"90", "day_id"=>"1"}, "1"=>{"open"=>"14:22", "close"=>"14:22", "rest_id"=>"90", "day_id"=>"2"}, "2"=>{"open"=>"15:32", "close"=>"15:33", "rest_id"=>"90", "day_id"=>"3"}, "3"=>{"open"=>"03:22", "close"=>"15:32", "rest_id"=>"90", "day_id"=>"4"}, "4"=>{"open"=>"16:44", "close"=>"21:09", "rest_id"=>"90", "day_id"=>"5"}, "5"=>{"open"=>"18:06", "close"=>"19:07", "rest_id"=>"90", "day_id"=>"6"}, "6"=>{"open"=>"08:08", "close"=>"20:08", "rest_id"=>"90", "day_id"=>"7"}}, "user_id"=>"90")
    @restaurant2 = Restaurant.new("description"=>"124", "price"=>"1", "address"=>"123", "rest_type"=>"Italian", "zip" =>"94704", "city" =>"berkeley1", "hours_attributes"=>{"0"=>{"open"=>"11:11", "close"=>"11:11", "rest_id"=>"90", "day_id"=>"1"}, "1"=>{"open"=>"14:22", "close"=>"14:22", "rest_id"=>"90", "day_id"=>"2"}, "2"=>{"open"=>"15:32", "close"=>"15:33", "rest_id"=>"90", "day_id"=>"3"}, "3"=>{"open"=>"03:22", "close"=>"15:32", "rest_id"=>"90", "day_id"=>"4"}, "4"=>{"open"=>"16:44", "close"=>"21:09", "rest_id"=>"90", "day_id"=>"5"}, "5"=>{"open"=>"18:06", "close"=>"19:07", "rest_id"=>"90", "day_id"=>"6"}, "6"=>{"open"=>"08:08", "close"=>"20:08", "rest_id"=>"90", "day_id"=>"7"}}, "user_id"=>"90")
    @user = User.create(id: 2, name: 'user 1', email: 'AtidJenad@gmail.com', rest: false, password: '123123123', password_confirmation: '123123123')
    @user.save
    @restaurant.save
    @restaurant2.save
    
    # create user as restaurant and populate into database
    @user_rest = User.create(name: "test2", email: "test2@gmail.com", password:"foobar12", password_confirmation: "foobar12",
            rest: true)
    @user_rest2 = User.create(name: "test1", email: "test1@gmail.com", password:"foobar13", password_confirmation: "foobar13",
            rest: true)
    @rest = Restaurant.create(user_id: @user_rest.id)
    @rest1 = Restaurant.create(user_id: @user_rest2.id)
    @user_rest.save
    @user_rest2.save
    @rest1.save
    @rest.save

    post_via_redirect "/sign_in", 'user[email]' => @user.email, 'user[password]' => @user.password
  end

	# user can access favorite page after sign in
	test "user can add favorite after sign in" do
	  	get favorites_new_path	
	  	assert_response :success
	end

	# before sign in, user cannot access the favorite page
	# they are instead redirected to login page
	test "user unable to favorite before sign in" do
	  	delete destroy_user_session_path
	  	get favorites_new_path
	  	assert_redirected_to login_path
	end

	# customer successfully add favorite
	test "customer favorite success" do
		post '/favorites', favorite: {cust_id: @user.id, rest_id: @rest.user_id}
	  	assert_not_nil Favorite.where(cust_id: @user.id)
	end

	# customer cannot add favorite in the same restaurant at the same time multiple times
	test "customer favorite fail" do
		# put favorite
		post '/favorites_new', favorite: {cust_id: @user.id, rest_id: @rest.user_id}

		# put favorite the second time and check that it is not saved into database
		assert_no_difference 'Favorite.count' do
  			post '/favorites', favorite: {cust_id: @user.id, rest_id: @rest.user_id}
		end
	end

	# customer can favorite in 2 different restaurants at the same time
	test "customer favorite multiple rests success" do
		# creating temporary user as restaurant
		@user_tmp = User.create(name: "test3", email: "test3@gmail.com", password:"foobar13", password_confirmation: "foobar13",
		  			rest: true)
		@rest_tmp = Restaurant.create(user_id: @user_tmp.id)
		@user_tmp.save
		@rest_tmp.save

		# put favorite in 2 different restaurants and check the database
		post '/favorites', rest_id: @rest.user_id
		post '/favorites', rest_id: @rest_tmp.user_id
		assert Favorite.where(cust_id: @user.id).size == 2
	end

	# customer can delete their favorite
	test "customer delete favorite success" do
		# post a favorite
		post '/favorites', rest_id: @rest.user_id
		@favorite = Favorite.where(cust_id: @user.id).first
		assert_not_nil @favorite.id

		# delete that specific favorite and check in the database that it is deleted
		get '/favorites_dest?rest_id=' + @rest.user_id.to_s
		assert_nil Favorite.where(rest_id: @rest.user_id).first
	end
end
