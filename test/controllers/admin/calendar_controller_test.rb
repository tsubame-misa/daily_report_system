require "test_helper"

class Admin::CalendarControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_calendar_index_url
    assert_response :success
  end
end
