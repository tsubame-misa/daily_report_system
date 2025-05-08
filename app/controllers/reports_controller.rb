class ReportsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_report, only: %i[show edit update destroy]
  before_action :set_origin, only: %i[show edit destroy]
  before_action :set_origins, only: %i[show edit destroy]

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
               .keyword_search(keyword, ["reports.title", "reports.contents"])
    if @favorite_only
      favorite_report_ids = current_user.favorites.pluck(:report_id)
      @reports = @reports.where(id: favorite_report_ids)
    end
  end

  def show
    render locals: { hide_sub_header: true }
  end

  def new
    @report = current_user.reports.build
    referer = request.referer
    referer_path = referer.present? ? URI.parse(referer).path : nil
    if referer_path == calendar_month_path
      if params[:date].present?
        selected_month = Date.parse(params[:date]).strftime('%Y-%m')
        @cancel_path = calendar_month_path(month: selected_month)
      else
        @cancel_path = calendar_month_path
      end
    elsif referer_path&.start_with?(reports_path)
      @cancel_path = reports_path
    else
      @cancel_path = calendar_month_path
    end
    render locals: { hide_sub_header: true }
  end

  def create
    @report = current_user.reports.build(report_params)
    redirect_path = params[:from].presence || reports_path
    if @report.save
      redirect_to redirect_path, notice: '日報が作成されました。'
    else
      flash.now[:alert] = @report.formatted_error_messages
      render :new, locals: { hide_sub_header: true }, status: :unprocessable_entity
    end
  end

  def edit
    render locals: { hide_sub_header: true }
  end

  def update
    if @report.update(report_params)
      redirect_to report_path(@report), notice: '日報を更新しました。'
    else
      flash.now[:alert] = @report.formatted_error_messages
      render :edit, locals: { hide_sub_header: true }, status: :unprocessable_entity
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
