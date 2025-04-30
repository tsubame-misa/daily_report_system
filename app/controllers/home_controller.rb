class HomeController < ApplicationController
  def index
    # adminじゃなかったら、reportsにリダイレクトする
    if user_signed_in? && !current_user.admin?
      redirect_to reports_path
    else
      @reports = Report.order(created_at: :desc).limit(3) || []
      # redirect_to report_calendar_index_path
      redirect_to admin_calendar_path
    end
  end
end