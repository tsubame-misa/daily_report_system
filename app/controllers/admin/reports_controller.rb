class Admin::ReportsController < Admin::BaseController
  before_action :set_report, only: %i[show destroy edit update]

  def index
    start_date = params[:start_date]
    end_date   = params[:end_date]
    keyword    = params[:q]
    sort       = params[:sort]
    direction  = params[:direction]
    @favorite_only = ActiveModel::Type::Boolean.new.cast(params[:favorite_only])
  
    @reports = Report.includes(:user).all
  
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

  def show; end

  def edit
    @admin_context = true
  end

  def update
    @report.update(report_params)
    if @report.save
      redirect_to admin_reports_path, notice: "日報を更新しました。"
    else
      @admin_context = true
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @report.destroy
    redirect_to admin_reports_path, notice: '日報が削除されました。'
  end

  private

  def set_report
    @report = Report.find_by(id: params[:id])
    not_found unless @report
  end

  def report_params
    params.require(:report).permit(:report_date, :title, :contents)
  end
end
