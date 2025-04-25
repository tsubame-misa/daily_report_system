class ReportsController < ApplicationController
  def index
    @reports = Report.where(user_id: current_user.id).order(created_at: :desc)
    # admin.reports.indexを表示
    render 'admin/reports/index'
  end
end
