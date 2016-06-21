require 'rails_helper'

RSpec.describe "carts/new", type: :view do
  before(:each) do
    assign(:cart, Cart.new(
      :cust_id => 1,
      :rest_id => 1,
      :version => 1,
      :menu_id => 1,
      :qty => 1
    ))
  end

  it "renders new cart form" do
    render

    assert_select "form[action=?][method=?]", carts_path, "post" do

      assert_select "input#cart_cust_id[name=?]", "cart[cust_id]"

      assert_select "input#cart_rest_id[name=?]", "cart[rest_id]"

      assert_select "input#cart_version[name=?]", "cart[version]"

      assert_select "input#cart_menu_id[name=?]", "cart[menu_id]"

      assert_select "input#cart_qty[name=?]", "cart[qty]"
    end
  end
end
