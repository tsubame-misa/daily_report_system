class HomeController < ApplicationController
  def index
    if user_signed_in?
      if current_user.admin?
        referer = request.referer
        if referer.present? && URI.parse(referer).path.start_with?('/admin')
          redirect_to admin_calendar_month_path
        else
          redirect_to calendar_month_path
        end
      else
        redirect_to calendar_month_path
      end
    else
      @reports = Report.order(created_at: :desc).limit(3)
    end
  end
end
