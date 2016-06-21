require 'rails_helper'

RSpec.describe "versions/new", type: :view do
  before(:each) do
    assign(:version, Version.new(
      :cust_id => 1,
      :rest_id => 1,
      :count => 1
    ))
  end

  it "renders new version form" do
    render

    assert_select "form[action=?][method=?]", versions_path, "post" do

      assert_select "input#version_cust_id[name=?]", "version[cust_id]"

      assert_select "input#version_rest_id[name=?]", "version[rest_id]"

      assert_select "input#version_count[name=?]", "version[count]"
    end
  end
end
