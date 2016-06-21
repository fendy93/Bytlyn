require 'rails_helper'

RSpec.describe "deliveries/edit", type: :view do
  before(:each) do
    @delivery = assign(:delivery, Delivery.create!(
      :phone => 1,
      :rest_id => 1,
      :version => 1,
      :user_id => 1,
      :address => "MyString",
      :total => 1.5
    ))
  end

  it "renders the edit delivery form" do
    render

    assert_select "form[action=?][method=?]", delivery_path(@delivery), "post" do

      assert_select "input#delivery_phone[name=?]", "delivery[phone]"

      assert_select "input#delivery_rest_id[name=?]", "delivery[rest_id]"

      assert_select "input#delivery_version[name=?]", "delivery[version]"

      assert_select "input#delivery_user_id[name=?]", "delivery[user_id]"

      assert_select "input#delivery_address[name=?]", "delivery[address]"

      assert_select "input#delivery_total[name=?]", "delivery[total]"
    end
  end
end
