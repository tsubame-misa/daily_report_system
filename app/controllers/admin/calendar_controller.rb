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
    if @favorite_only
      favorite_report_ids = current_user.favorites.pluck(:report_id)
      @reports = @reports.where(id: favorite_report_ids)
    end
  end
end
