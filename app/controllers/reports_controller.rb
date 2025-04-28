class ReportsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_report, only: [:edit, :update, :destroy]

  def index
    start_date = params[:start_date]
    end_date = params[:end_date]
    keyword = params[:q]
    if start_date.present? && end_date.present? && start_date > end_date
      @date_range_error = '開始日が終了日より後になっています。正しい日付範囲を指定してください。'
      @reports = Report.where(user_id: current_user.id).order(created_at: :desc)
    else
      @reports = Report.where(user_id: current_user.id)
                     .by_date_range(start_date, end_date)
                     .order(created_at: :desc)
    end
    if keyword.present?
      @reports = @reports.joins(:user)
                         .where('reports.title LIKE :keyword OR users.name LIKE :keyword', keyword: "%#{keyword}%")
    end
  end

  def show
    @report = Report.find_by(id: params[:id], user_id: current_user.id)
    not_found unless @report
  end

  def new
    @report = current_user.reports.build
  end

  def create
    @report = current_user.reports.build(report_params)
    if @report.save
      redirect_to reports_path, notice: "日報が作成されました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @report.update(report_params)
    if @report.save
      redirect_to reports_path, notice: "日報を更新しました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @report.destroy
    redirect_to reports_path, notice: "日報が削除されました。"
  end

  private

  def set_report
    @report = current_user.reports.find(params[:id])
  end

  def report_params
    params.require(:report).permit(:title, :contents, :report_date)
  end
end
