class HomeController < ApplicationController
  def index
    if user_signed_in?
      if current_user.admin?
        redirect_to admin_calendar_day_path
      else
        redirect_to calendar_month_path
      end
    else
      @reports = Report.order(created_at: :desc).limit(3)
    end
  end
end
