require "test_helper"

class ParentalConsentsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get parental_consents_new_url
    assert_response :success
  end

  test "should get create" do
    get parental_consents_create_url
    assert_response :success
  end
end
