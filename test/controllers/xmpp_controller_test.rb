require 'test_helper'

class XmppControllerTest < ActionController::TestCase
  test "should get show" do
    get :show
    assert_response :success
  end

  test "should get refresh" do
    get :refresh
    assert_response :success
  end

end
