require 'rails_helper'

RSpec.describe "deliveries/show", type: :view do
  before(:each) do
    @delivery = assign(:delivery, Delivery.create!(
      :phone => 1,
      :rest_id => 2,
      :version => 3,
      :user_id => 4,
      :address => "Address",
      :total => 1.5
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/4/)
    expect(rendered).to match(/Address/)
    expect(rendered).to match(/1.5/)
  end
end
