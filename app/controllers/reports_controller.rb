class ReportsController < ApplicationController
  before_action :authenticate_user!

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
    params.require(:report).permit(:title, :contents)
  end

end
