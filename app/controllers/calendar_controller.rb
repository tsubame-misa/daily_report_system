class CalendarController < ApplicationController
  before_action :authenticate_user!

  def month
    set_calendar_dates
    fetch_reports
  end

  private

  def set_calendar_dates
    @selected_date = if params[:date].present?
                       Date.parse("#{params[:date]}-01")
                     else
                       Date.today
                     end

    @selected_month = @selected_date.month
    @selected_year = @selected_date.year

    @prev_month = (@selected_date - 1.month).strftime('%Y-%m')
    @next_month = (@selected_date + 1.month).strftime('%Y-%m')

    # 選択された月の最初の日と最後の日を取得
    first_day = Date.new(@selected_year, @selected_month, 1)
    last_day = first_day.end_of_month

    # カレンダーの週を構築
    @calendar_weeks = build_calendar_weeks(first_day, last_day)
  end

  def build_calendar_weeks(first_day, last_day)
    # 必要な週の数を計算
    total_weeks = (first_day.wday + last_day.day + 6) / 7
    calendar_weeks = Array.new(total_weeks) { Array.new(7, nil) }

    # 日付を適切な位置に配置
    current_date = first_day
    while current_date <= last_day
      week_index = (current_date.day + first_day.wday - 1) / 7
      day_index = current_date.wday
      calendar_weeks[week_index][day_index] = current_date
      current_date += 1
    end

    calendar_weeks
  end

  def fetch_reports
    # 選択された月の最初の日と最後の日を取得
    first_day = Date.new(@selected_year, @selected_month, 1)
    last_day = first_day.end_of_month

    # ユーザーの指定期間内の日報を取得
    reports = Report.where(
      user_id: current_user.id,
      report_date: first_day.beginning_of_day..last_day.end_of_day
    )

    # 日付ごとの最初の日報IDをハッシュで保持
    @report_dates = reports.group_by { |report| report.report_date.to_date }
                           .transform_values { |reports| reports.first.id }
  end
end
