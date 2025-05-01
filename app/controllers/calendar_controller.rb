class CalendarController < ApplicationController
  before_action :authenticate_user!

  def month
    # monthというqueryパラメータがあれば、その月を表示
    @selected_date = params[:month].present? ? Date.parse("#{params[:month]}-01") : Date.today
    @selected_month = @selected_date.month
    @selected_year = @selected_date.year

    # 先月・翌月の値を設定
    @prev_month = (@selected_date - 1.month).strftime('%Y-%m')
    @next_month = (@selected_date + 1.month).strftime('%Y-%m')

    first_day = Date.new(@selected_year, @selected_month, 1)
    last_day = first_day.end_of_month
    start_date = first_day.beginning_of_week(:sunday)
    end_date = last_day.end_of_week(:sunday)

    @dates = (start_date..end_date).to_a.in_groups_of(7)

    reports = Report.includes(:user, :favorites)
                    .where(user_id: current_user.id)
                    .where(report_date: start_date.beginning_of_day..end_date.end_of_day)

    @reports_by_date = reports.group_by(&:report_date)
                              .transform_values { |daily_reports| daily_reports.take(3) }
  end
end
