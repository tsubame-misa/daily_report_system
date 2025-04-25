class ReportsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_report, only: [:edit, :update, :destroy]

  # def index
  # end
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

  def edit
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
    params.require(:report).permit(:title, :contents)
  end
end
