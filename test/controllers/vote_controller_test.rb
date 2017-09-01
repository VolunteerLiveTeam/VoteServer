require 'test_helper'

class VoteControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get vote_index_url
    assert_response :success
  end

  test "should get create" do
    get vote_create_url
    assert_response :success
  end

  test "should get thankyou" do
    get vote_thankyou_url
    assert_response :success
  end

end
