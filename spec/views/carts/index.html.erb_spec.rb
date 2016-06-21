require 'rails_helper'

RSpec.describe "carts/index", type: :view do
  before(:each) do
    assign(:carts, [
      Cart.create!(
        :cust_id => 1,
        :rest_id => 2,
        :version => 3,
        :menu_id => 4,
        :qty => 5
      ),
      Cart.create!(
        :cust_id => 1,
        :rest_id => 2,
        :version => 3,
        :menu_id => 4,
        :qty => 5
      )
    ])
  end

  it "renders a list of carts" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => 5.to_s, :count => 2
  end
end
