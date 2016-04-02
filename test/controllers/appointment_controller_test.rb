require 'test_helper'

class AppointmentControllerTest < ActionController::TestCase
  test "should get create" do
    get :create
    assert_response :success
  end

  test "should get re_schedule" do
    get :re_schedule
    assert_response :success
  end

  test "should get cancel" do
    get :cancel
    assert_response :success
  end

end
