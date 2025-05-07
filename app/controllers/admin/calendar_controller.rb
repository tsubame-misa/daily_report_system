class Admin::CalendarController < Admin::BaseController
  before_action :authenticate_user!
  def day
    @selected_date = params[:date].present? ? Date.parse("#{params[:date]}") : Date.today
    @previous_date = (@selected_date - 1.day).strftime('%Y-%m-%d')
    @next_date = (@selected_date + 1.day).strftime('%Y-%m-%d')

    # start_date = params[:start_date]
    # end_date   = params[:end_date]
    # keyword    = params[:q]
    # sort       = params[:sort]
    # direction  = params[:direction]
    # @favorite_only = ActiveModel::Type::Boolean.new.cast(params[:favorite_only])

    @reports = Report.includes(:user)
    @reports = @reports.where(report_date: @selected_date).keyword_search(params[:q])

    return unless ActiveModel::Type::Boolean.new.cast(params[:favorite_only])

    favorite_report_ids = current_user.favorites.pluck(:report_id)
    @reports = @reports.where(id: favorite_report_ids)

    # @reports = @reports
    #            .sorted_by(sort, direction)
    #            .keyword_search(keyword)
    # return unless @favorite_only

    # favorite_report_ids = current_user.favorites.pluck(:report_id)
    # @reports = @reports.where(id: favorite_report_ids)
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

    # 期間内の全レポートを取得
    all_reports = Report.includes(:user, :favorites)
                        .where(report_date: start_date.beginning_of_day..end_date.end_of_day)
                        .keyword_search(params[:q])

    if ActiveModel::Type::Boolean.new.cast(params[:favorite_only])
      favorite_report_ids = current_user.favorites.pluck(:report_id)
      all_reports = all_reports.where(id: favorite_report_ids)
    end

    # 日付ごとのレポート数を保持
    @reports_count_by_date = all_reports.group(:report_date).count

    # カレンダーに表示する各日付の最新3件のレポート
    @calendar_preview_reports = all_reports.group_by(&:report_date)
                                           .transform_values { |daily_reports| daily_reports.take(3) }
  end
end
