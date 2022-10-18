require "test_helper"

class SwapsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get swaps_index_url
    assert_response :success
  end
end
