require 'test_helper'

class HourTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "successful new hour" do
    @hour = Hour.new(open:"10:11",close: "11:11",rest_id: 1, day_id: 1)
    assert @hour.save
  end
  test "not successful no day id out of range" do
    @hour = Hour.new(open:"10:11",close: "11:11",rest_id: 1, day_id: 8)
    assert_equal(@hour.save, false)
    @hour = Hour.new(open:"10:11",close: "11:11",rest_id: 1, day_id: 0)
    assert_equal(@hour.save, false)
    @hour = Hour.new(open:"10:11",close: "11:11",rest_id: 1)
    assert_equal(@hour.save, false)
  end
  test "not successful no rest id" do
    @hour = Hour.new(open:"10:11",close: "11:11", day_id: 3)
    assert_equal(@hour.save, false)

  end
  test "not unique day rest id pair" do 
    @hour = Hour.new(open:"10:11",close: "11:11",rest_id: 1, day_id: 1)
    assert @hour.save
    @hour = Hour.new(open:"10:11",close: "11:11",rest_id: 1, day_id: 1)
    assert_equal(@hour.save, false)

  end


  test "open hour > close hour" do
    @hour = Hour.new(open:"12:12",close: "11:11",rest_id: 1, day_id: 1)
    assert_equal(@hour.save, false)

  end
end
