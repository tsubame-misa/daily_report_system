require "test_helper"

class ReportCalendarControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get report_calendar_index_url
    assert_response :success
  end

  test "should get show" do
    get report_calendar_show_url
    assert_response :success
  end

  test "should get new" do
    get report_calendar_new_url
    assert_response :success
  end
end
