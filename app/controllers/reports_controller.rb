class ReportsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @reports = Report.where(user_id: current_user.id).order(created_at: :desc)
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

  private
  def report_params
    params.require(:report).permit(:title, :contents, :report_date)
  end

end
