class Admin::ReportsController < Admin::BaseController
  before_action :set_report, only: %i[show destroy edit update]

  def index
    @reports = Report.all
                     .includes(:user)
                     .sorted_by(params[:sort], params[:direction])
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
