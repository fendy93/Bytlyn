require 'rails_helper'

RSpec.describe "versions/index", type: :view do
  before(:each) do
    assign(:versions, [
      Version.create!(
        :cust_id => 1,
        :rest_id => 2,
        :count => 3
      ),
      Version.create!(
        :cust_id => 1,
        :rest_id => 2,
        :count => 3
      )
    ])
  end

  it "renders a list of versions" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
  end
end
