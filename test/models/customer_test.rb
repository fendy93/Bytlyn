require 'test_helper'

class CustomerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  setup do
    @customer = Customer.new(user_id:2, phone_number: 0000)
    @customer.save
   
    @user = User.new(id: 2, name: 'user 1', email: 'AtidJenad@gmail.com', rest: false, password: '123123123', password_confirmation: '123123123')
    @user.save

  end

  def test_correct_customer
    cust = Customer.new :user_id => "3", :phone_number => 00000              
    status = cust.save
    assert_equal(status, true)
  end

  # def test_user_id
  #   cust = Customer.new :user_id => "", :phone_number => 00000              
  #   assert_false cust.save

  #   cust = @customer.dup
  #   assert_false cust.save
  # end
end
