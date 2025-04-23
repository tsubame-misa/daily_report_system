class HomeController < ApplicationController
  def index
    @reports = Report.order(created_at: :desc).limit(3) || []
  end
end