require "test_helper"

class ConsentApprovalsControllerTest < ActionDispatch::IntegrationTest
  test "should get approve" do
    get consent_approvals_approve_url
    assert_response :success
  end

  test "should get deny" do
    get consent_approvals_deny_url
    assert_response :success
  end
end
