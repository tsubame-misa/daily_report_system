class Admin::ReportsController < Admin::BaseController
  before_action :set_report, only: %i[show destroy]

  def index
    @reports = Report.all
                     .includes(:user)
                     .by_date_range(params[:start_date],params[:end_date])
                     .sorted_by(params[:sort], params[:direction])
  end

  def show; end

  def destroy
    @report.destroy
    redirect_to admin_reports_path, notice: '日報が削除されました。'
  end

  private

  def set_report
    @report = Report.find_by(id: params[:id])
    not_found unless @report
  end
end
