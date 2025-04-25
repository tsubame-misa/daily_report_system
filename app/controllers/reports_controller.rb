class ReportsController < ApplicationController
  def index
    @reports = Report.where(user_id: current_user.id).order(created_at: :desc)
  end

  def show
    @report = Report.find_by(id: params[:id], user_id: current_user.id)
  end
end
