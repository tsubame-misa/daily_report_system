class Admin::CalendarController < ApplicationController
  def index
    start_date = params[:start_date]
    end_date   = params[:end_date]
    keyword    = params[:q]
    sort       = params[:sort]
    direction  = params[:direction]
    @favorite_only = ActiveModel::Type::Boolean.new.cast(params[:favorite_only])
    selected_date = params[:date].present? ? Date.parse(params[:date]) : Date.today
    @selected_date = selected_date

    @reports = Report.includes(:user)
    @reports = @reports.where(report_date: selected_date)

    if start_date.present? && end_date.present? && start_date > end_date
      @date_range_error = '開始日が終了日より後になっています。正しい日付範囲を指定してください。'
    else
      @reports = @reports.by_date_range(start_date, end_date)
    end

    @reports = @reports
               .sorted_by(sort, direction)
               .keyword_search(keyword)
    return unless @favorite_only

    favorite_report_ids = current_user.favorites.pluck(:report_id)
    @reports = @reports.where(id: favorite_report_ids)
  end

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
                    .where(report_date: start_date.beginning_of_day..end_date.end_of_day)

    @reports_by_date = reports.group_by(&:report_date)
                              .transform_values { |daily_reports| daily_reports.take(3) }
  end
end
