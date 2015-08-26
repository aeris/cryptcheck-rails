require 'test_helper'

class CheckControllerTest < ActionController::TestCase
  test "should get result" do
    get :show
    assert_response :success
  end

  test "should get refresh" do
    get :refresh
    assert_response :success
  end

end
