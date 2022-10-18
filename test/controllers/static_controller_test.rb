require "test_helper"

class StaticControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get static_home_url
    assert_response :success
  end

  test "should get features" do
    get static_features_url
    assert_response :success
  end

  test "should get legal" do
    get static_legal_url
    assert_response :success
  end
end
