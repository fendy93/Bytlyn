require 'rails_helper'

RSpec.describe "carts/show", type: :view do
  before(:each) do
    @cart = assign(:cart, Cart.create!(
      :cust_id => 1,
      :rest_id => 2,
      :version => 3,
      :menu_id => 4,
      :qty => 5
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/4/)
    expect(rendered).to match(/5/)
  end
end
