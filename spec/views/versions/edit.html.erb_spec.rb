require 'rails_helper'

RSpec.describe "versions/edit", type: :view do
  before(:each) do
    @version = assign(:version, Version.create!(
      :cust_id => 1,
      :rest_id => 1,
      :count => 1
    ))
  end

  it "renders the edit version form" do
    render

    assert_select "form[action=?][method=?]", version_path(@version), "post" do

      assert_select "input#version_cust_id[name=?]", "version[cust_id]"

      assert_select "input#version_rest_id[name=?]", "version[rest_id]"

      assert_select "input#version_count[name=?]", "version[count]"
    end
  end
end
