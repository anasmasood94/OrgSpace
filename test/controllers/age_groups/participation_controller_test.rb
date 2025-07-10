require "test_helper"

class AgeGroups::ParticipationControllerTest < ActionDispatch::IntegrationTest
  test "should get minors" do
    get age_groups_participation_minors_url
    assert_response :success
  end

  test "should get adults" do
    get age_groups_participation_adults_url
    assert_response :success
  end
end
