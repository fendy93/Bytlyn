require "json"
require "selenium-webdriver"
require "rspec"
include RSpec::Expectations

describe "SignUpUserPage" do

  before(:each) do
    @driver = Selenium::WebDriver.for :firefox
    @base_url = "http://localhost:3000/"
    @accept_next_alert = true
    @driver.manage.timeouts.implicit_wait = 30
    @verification_errors = []
  end
  
  after(:each) do
    @driver.quit
    @verification_errors.should == []
  end
  
  it "test_sign_up_user_page" do
    @driver.get(@base_url + "/index")
    @driver.find_element(:xpath, "//a[@href = '/signup']").click
    @driver.find_element(:xpath, "//div[contains(@class, 'text') and text() = 'User']").click
    @driver.find_element(:id, "user_name").clear
    @driver.find_element(:id, "user_name").send_keys "user_test"
    @driver.find_element(:id, "user_password").clear
    @driver.find_element(:id, "user_password").send_keys "testtest"
    @driver.find_element(:id, "user_password_confirmation").clear
    @driver.find_element(:id, "user_password_confirmation").send_keys "testtest"
    @driver.find_element(:id, "user_email").clear
    @driver.find_element(:id, "user_email").send_keys "user_test@gmail.com"
    @driver.find_element(:name, "commit").click
    # Warning: assertTextPresent may require manual changes
    @driver.find_element(:css, "BODY").text.should =~ /^[\s\S]*user_test[\s\S]*$/
    @driver.find_element(:xpath, "//a[@href = '/users/sign_out']").click
  end
  
  def element_present?(how, what)
    @driver.find_element(how, what)
    true
  rescue Selenium::WebDriver::Error::NoSuchElementError
    false
  end
  
  def alert_present?()
    @driver.switch_to.alert
    true
  rescue Selenium::WebDriver::Error::NoAlertPresentError
    false
  end
  
  def verify(&blk)
    yield
  rescue ExpectationNotMetError => ex
    @verification_errors << ex
  end
  
  def close_alert_and_get_its_text(how, what)
    alert = @driver.switch_to().alert()
    alert_text = alert.text
    if (@accept_next_alert) then
      alert.accept()
    else
      alert.dismiss()
    end
    alert_text
  ensure
    @accept_next_alert = true
  end
end
