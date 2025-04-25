class ReportsController < ApplicationController
  def index
    @reports = Report.order(created_at: :desc)
    render template: "admin/reports/index"
  end
end
