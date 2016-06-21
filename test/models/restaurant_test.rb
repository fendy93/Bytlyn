require 'test_helper'
# require File.dirname(__FILE__) + '/../test_helper'

class RestaurantTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  fixtures :restaurants

  def test_user_id

    rest =   Restaurant.new "description"=>"123", "price"=>"123", "address"=>"123", "rest_type"=>"Italian", "hours_attributes"=>{"0"=>{"open"=>"11:11", "close"=>"11:11", "rest_id"=>"34", "day_id"=>"1"}, "1"=>{"open"=>"14:22", "close"=>"14:22", "rest_id"=>"34", "day_id"=>"1"}, "2"=>{"open"=>"15:32", "close"=>"15:33", "rest_id"=>"34", "day_id"=>"1"}, "3"=>{"open"=>"03:22", "close"=>"15:32", "rest_id"=>"34", "day_id"=>"1"}, "4"=>{"open"=>"16:44", "close"=>"21:09", "rest_id"=>"34", "day_id"=>"1"}, "5"=>{"open"=>"18:06", "close"=>"19:07", "rest_id"=>"34", "day_id"=>"1"}, "6"=>{"open"=>"08:08", "close"=>"20:08", "rest_id"=>"34", "day_id"=>"1"}}, "user_id"=>"34"
    assert rest.save

    rest_copy = Restaurant.find(rest.id)

    assert_equal rest.user_id, rest_copy.user_id
  end

  def test_address

    rest =   Restaurant.new "description"=>"123", "price"=>"123", "address"=>"123", "rest_type"=>"Italian", "hours_attributes"=>{"0"=>{"open"=>"11:11", "close"=>"11:11", "rest_id"=>"34", "day_id"=>"1"}, "1"=>{"open"=>"14:22", "close"=>"14:22", "rest_id"=>"34", "day_id"=>"1"}, "2"=>{"open"=>"15:32", "close"=>"15:33", "rest_id"=>"34", "day_id"=>"1"}, "3"=>{"open"=>"03:22", "close"=>"15:32", "rest_id"=>"34", "day_id"=>"1"}, "4"=>{"open"=>"16:44", "close"=>"21:09", "rest_id"=>"34", "day_id"=>"1"}, "5"=>{"open"=>"18:06", "close"=>"19:07", "rest_id"=>"34", "day_id"=>"1"}, "6"=>{"open"=>"08:08", "close"=>"20:08", "rest_id"=>"34", "day_id"=>"1"}}, "user_id"=>"34"
    assert rest.save

    rest_copy = Restaurant.find(rest.id)

    assert_equal rest.address, rest_copy.address
  end

  def test_all_correct_info
    rest =   Restaurant.new "description"=>"123", "price"=>"432", "address"=>"zzz", "rest_type"=>"Italian", "hours_attributes"=>{"0"=>{"open"=>"11:11", "close"=>"11:11", "rest_id"=>"34", "day_id"=>"1"}, "1"=>{"open"=>"14:22", "close"=>"14:22", "rest_id"=>"34", "day_id"=>"1"}, "2"=>{"open"=>"15:32", "close"=>"15:33", "rest_id"=>"34", "day_id"=>"1"}, "3"=>{"open"=>"03:22", "close"=>"15:32", "rest_id"=>"34", "day_id"=>"1"}, "4"=>{"open"=>"16:44", "close"=>"21:09", "rest_id"=>"34", "day_id"=>"1"}, "5"=>{"open"=>"18:06", "close"=>"19:07", "rest_id"=>"34", "day_id"=>"1"}, "6"=>{"open"=>"08:08", "close"=>"20:08", "rest_id"=>"34", "day_id"=>"1"}}, "user_id"=>"34"
    assert rest.save
    assert_equal(rest.description, "123")
    assert_equal(rest.price, 432)
    assert_equal(rest.address, "zzz")
    assert_equal(rest.rest_type, "Italian")
    assert_equal(rest.user_id, 34)
    
  end

  def test_no_duplicate
    rest =   Restaurant.new "description"=>"123", "price"=>"123", "address"=>"123", "rest_type"=>"Italian", "hours_attributes"=>{"0"=>{"open"=>"11:11", "close"=>"11:11", "rest_id"=>"34", "day_id"=>"1"}, "1"=>{"open"=>"14:22", "close"=>"14:22", "rest_id"=>"34", "day_id"=>"1"}, "2"=>{"open"=>"15:32", "close"=>"15:33", "rest_id"=>"34", "day_id"=>"1"}, "3"=>{"open"=>"03:22", "close"=>"15:32", "rest_id"=>"34", "day_id"=>"1"}, "4"=>{"open"=>"16:44", "close"=>"21:09", "rest_id"=>"34", "day_id"=>"1"}, "5"=>{"open"=>"18:06", "close"=>"19:07", "rest_id"=>"34", "day_id"=>"1"}, "6"=>{"open"=>"08:08", "close"=>"20:08", "rest_id"=>"34", "day_id"=>"1"}}, "user_id"=>"34"
    assert rest.save
    rest_copy = Restaurant.find(rest.id)
    assert_equal rest.address, rest_copy.address
    rest =   Restaurant.new "description"=>"123", "price"=>"123", "address"=>"123", "rest_type"=>"Italian", "hours_attributes"=>{"0"=>{"open"=>"11:11", "close"=>"11:11", "rest_id"=>"34", "day_id"=>"1"}, "1"=>{"open"=>"14:22", "close"=>"14:22", "rest_id"=>"34", "day_id"=>"1"}, "2"=>{"open"=>"15:32", "close"=>"15:33", "rest_id"=>"34", "day_id"=>"1"}, "3"=>{"open"=>"03:22", "close"=>"15:32", "rest_id"=>"34", "day_id"=>"1"}, "4"=>{"open"=>"16:44", "close"=>"21:09", "rest_id"=>"34", "day_id"=>"1"}, "5"=>{"open"=>"18:06", "close"=>"19:07", "rest_id"=>"34", "day_id"=>"1"}, "6"=>{"open"=>"08:08", "close"=>"20:08", "rest_id"=>"34", "day_id"=>"1"}}, "user_id"=>"34"
    assert_equal(false, rest.save)
  end
  def test_generate_relation_hours
    rest =   Restaurant.new "description"=>"123", "price"=>"123", "address"=>"123", "rest_type"=>"Italian", "hours_attributes"=>{"0"=>{"open"=>"11:11", "close"=>"11:11", "rest_id"=>"34", "day_id"=>"1"}, "1"=>{"open"=>"14:22", "close"=>"14:22", "rest_id"=>"34", "day_id"=>"1"}, "2"=>{"open"=>"15:32", "close"=>"15:33", "rest_id"=>"34", "day_id"=>"1"}, "3"=>{"open"=>"03:22", "close"=>"15:32", "rest_id"=>"34", "day_id"=>"1"}, "4"=>{"open"=>"16:44", "close"=>"21:09", "rest_id"=>"34", "day_id"=>"1"}, "5"=>{"open"=>"18:06", "close"=>"19:07", "rest_id"=>"34", "day_id"=>"1"}, "6"=>{"open"=>"08:08", "close"=>"20:08", "rest_id"=>"34", "day_id"=>"1"}}, "user_id"=>"34"
    @hour = Hour.new "open"=>"11:11", "close"=>"11:11", "rest_id"=>"34", "day_id"=>"1"
    assert rest.save
    assert @hour.save
    assert_equal(rest.hours.first, @hour)
  end

  def test_generate_relation_menu
    rest =   Restaurant.new "description"=>"123", "price"=>"123", "address"=>"123", "rest_type"=>"Italian", "hours_attributes"=>{"0"=>{"open"=>"11:11", "close"=>"11:11", "rest_id"=>"34", "day_id"=>"1"}, "1"=>{"open"=>"14:22", "close"=>"14:22", "rest_id"=>"34", "day_id"=>"1"}, "2"=>{"open"=>"15:32", "close"=>"15:33", "rest_id"=>"34", "day_id"=>"1"}, "3"=>{"open"=>"03:22", "close"=>"15:32", "rest_id"=>"34", "day_id"=>"1"}, "4"=>{"open"=>"16:44", "close"=>"21:09", "rest_id"=>"34", "day_id"=>"1"}, "5"=>{"open"=>"18:06", "close"=>"19:07", "rest_id"=>"34", "day_id"=>"1"}, "6"=>{"open"=>"08:08", "close"=>"20:08", "rest_id"=>"34", "day_id"=>"1"}}, "user_id"=>"34"
    @menu = Menu.new "rest_id" => "34", "name" => 'pepes', "description" => "enak", "price" => "2"
    assert rest.save
    assert @menu.save
    assert_equal(rest.menus.first, @menu)
  end


  def test_count
    rest =   Restaurant.new "description"=>"123", "price"=>"123", "address"=>"123", "rest_type"=>"Italian", "hours_attributes"=>{"0"=>{"open"=>"11:11", "close"=>"11:11", "rest_id"=>"34", "day_id"=>"1"}, "1"=>{"open"=>"14:22", "close"=>"14:22", "rest_id"=>"34", "day_id"=>"1"}, "2"=>{"open"=>"15:32", "close"=>"15:33", "rest_id"=>"34", "day_id"=>"1"}, "3"=>{"open"=>"03:22", "close"=>"15:32", "rest_id"=>"34", "day_id"=>"1"}, "4"=>{"open"=>"16:44", "close"=>"21:09", "rest_id"=>"34", "day_id"=>"1"}, "5"=>{"open"=>"18:06", "close"=>"19:07", "rest_id"=>"34", "day_id"=>"1"}, "6"=>{"open"=>"08:08", "close"=>"20:08", "rest_id"=>"34", "day_id"=>"1"}}, "user_id"=>"34"
    assert rest.save

    rest_copy = Restaurant.find(rest.id)
    rest_count = Restaurant.count

    assert_equal 2, rest_count

    assert rest.save
    assert rest.destroy
  end

end
