require 'rails_helper'

RSpec.describe "deliveries/index", type: :view do
  before(:each) do
    assign(:deliveries, [
      Delivery.create!(
        :phone => 1,
        :rest_id => 2,
        :version => 3,
        :user_id => 4,
        :address => "Address",
        :total => 1.5
      ),
      Delivery.create!(
        :phone => 1,
        :rest_id => 2,
        :version => 3,
        :user_id => 4,
        :address => "Address",
        :total => 1.5
      )
    ])
  end

  it "renders a list of deliveries" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => "Address".to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
  end
end
