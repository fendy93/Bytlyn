require 'rails_helper'

RSpec.describe "versions/show", type: :view do
  before(:each) do
    @version = assign(:version, Version.create!(
      :cust_id => 1,
      :rest_id => 2,
      :count => 3
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
  end
end
