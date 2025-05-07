class ReportsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_report, only: %i[show edit update destroy]
  before_action :set_origin, only: %i[show edit]
  before_action :set_origins, only: %i[show edit]

  def index
    start_date = params[:start_date]
    end_date   = params[:end_date]
    keyword    = params[:q]
    sort       = params[:sort]
    direction  = params[:direction]
    @favorite_only = ActiveModel::Type::Boolean.new.cast(params[:favorite_only])

    @reports = Report.includes(:user).where(user_id: current_user.id)

    if start_date.present? && end_date.present? && start_date > end_date
      @date_range_error = '開始日が終了日より後になっています。正しい日付範囲を指定してください。'
    else
      @reports = @reports.by_date_range(start_date, end_date)
    end

    @reports = @reports
                 .sorted_by(sort, direction)
                 .keyword_search(keyword)
    if @favorite_only
      favorite_report_ids = current_user.favorites.pluck(:report_id)
      @reports = @reports.where(id: favorite_report_ids)
    end
  end

  def show; end

  def new
    @report = current_user.reports.build
  end

  def create
    @report = current_user.reports.build(report_params)
    if @report.save
      redirect_to calendar_month_path, notice: '日報が作成されました。'
    else
      flash.now[:alert] = @report.formatted_error_messages
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @report.update(report_params)
      redirect_to calendar_month_path, notice: '日報を更新しました。'
    else
      flash.now[:alert] = @report.formatted_error_messages
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @report.destroy
    redirect_to(session.delete(:origin_level1) || reports_path, notice: '日報が削除されました。')
  end

  private

  def set_report
    @report = current_user.reports.find_by(id: params[:id])
    not_found unless @report
  end

  def set_origin
    @origin = params[:origin] || request.referer || calendar_month_path
  end

  # セッションでoriginを管理
  def set_origins
    if action_name == 'show'
      # edit画面から戻ってきた場合はorigin_level1を上書きしない
      if request.referer&.include?(calendar_month_path) ||
         (request.referer&.include?(reports_path) && !request.referer&.include?('/edit'))
        session[:origin_level1] = request.referer
      end
      session.delete(:origin_level2)
    elsif action_name == 'edit'
      session[:origin_level2] = session[:origin_level1]
    end
    @origin_level1 = session[:origin_level1]
    @origin_level2 = session[:origin_level2]
  end

  def report_params
    params.require(:report).permit(:report_date, :title, :contents)
  end
end
