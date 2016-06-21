require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar123", password_confirmation: "foobar123", rest: false)
  end

  test "Correct login" do
    status = @user.save
    assert_equal(true, status)
  end

  test "No Name Not Saved" do 
    ex = User.new(name: "", email: "user@example.com",
                     password: "foobar123", password_confirmation: "foobar123", rest: false)
    status = ex.save
    assert_equal(false, status)
  end

  test "No Email" do
    ex = User.new(name: "Example User", email: "",
                     password: "foobar123", password_confirmation: "foobar123", rest: false)
    status = ex.save
    assert_equal(false, status)
  end

  test "No Password" do
    ex = User.new(name: "Example User", email: "user@example.com",
                     password: "", password_confirmation: "", rest: false)
    status = ex.save
    assert_equal(false, status)
  end

  test "No Rest" do
    ex = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar123", password_confirmation: "123", rest: "")
    status = ex.save
    assert_equal(false, status)
  end

  test "Password don't match" do
    ex = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar123", password_confirmation: "foobar111", rest: false)
    status = ex.save
    assert_equal(false, status)
  end
  test "duplicate email" do
    duplicate_user = User.new(name: "Boo", email: "user@example.com",
                     password: "foobae123", password_confirmation: "foobae123", rest: false)
    @user.save 
    status = duplicate_user.save
    assert_equal(false, status)
  end

  test "duplicate name" do
    duplicate_user = User.new(name: "Example User", email: "user1@example.com",
                     password: "foobar123", password_confirmation: "foobar123", rest: false)
    @user.save 
    status = duplicate_user.save
    assert_equal(true, status)

  end
  test "duplicate password" do
    duplicate_user = User.new(name: "Example User2", email: "user2@example.com",
                     password: "foobar123", password_confirmation: "foobar123", rest: false)
    @user.save 
    status = duplicate_user.save
    assert_equal(true, status)
  end
  test "password < 8" do
    ex = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar1", password_confirmation: "foobar1", rest: false)
    status = ex.save
    assert_equal(false, status)
  end

  test "Email regex bad" do
    ex = User.new(name: "Example User", email: "userexamplecom",
                     password: "foobar123", password_confirmation: "foobar123", rest: false)
    status = ex.save
    assert_equal(false, status)
    ex = User.new(name: "Example User", email: "user@examplecom",
                     password: "foobar123", password_confirmation: "foobar123", rest: false)
    status = ex.save
    assert_equal(false, status)
  end
  test "duplicate different case email" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    status = duplicate_user.save
    assert_equal(false, status)
  end
  test "payment info" do
    ex = User.new(name: "Example User", email: "userexamplecom",
                     password: "foobar123", password_confirmation: "foobar123", rest: false)
    assert_equal(nil, ex.has_payment_info?)
    ex = User.new(name: "Example User", email: "userexamlecom",
                     password: "foobar123", password_confirmation: "foobar123", rest: false, braintree_customer_id: 2)
    assert_equal("2", ex.has_payment_info?)
  end
end
