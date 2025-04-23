class Admin::ReportsController < Admin::BaseController
  before_action :set_report, only: [:show, :destroy]

  def index
    @reports = Report.all.order(created_at: :desc)
  end

  def show
  end

  def destroy
    @report.destroy
    redirect_to admin_reports_path, notice: "日報が削除されました。"
  end

  private

  def set_report
    @report = Report.find(params[:id])
  end
end
