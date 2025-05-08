class Admin::ReportsController < Admin::BaseController
  before_action :set_report, only: %i[show destroy edit update]
  before_action :set_admin_origins, only: %i[show edit destroy]

  def index
    start_date = params[:start_date]
    end_date   = params[:end_date]
    keyword    = params[:q]
    sort       = params[:sort]
    direction  = params[:direction]
    @favorite_only = ActiveModel::Type::Boolean.new.cast(params[:favorite_only])

    @reports = Report.includes(:user).all

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

  def edit
    @admin_context = true
  end

  def update
    if @report.update(report_params)
      redirect_to admin_report_path(@report), notice: '日報を更新しました。'
    else
      @admin_context = true
      flash.now[:alert] = @report.formatted_error_messages
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @report.destroy
    # セッションにadmin_origin_level1があればそこに戻る。なければreferer、さらにダメならadmin_reports_path
    redirect_to(session[:admin_origin_level1].presence || request.referer || admin_reports_path, notice: '日報が削除されました。')
    session.delete(:admin_origin_level1)
  end

  private

  def set_report
    @report = Report.find_by(id: params[:id])
    not_found unless @report
  end

  def set_admin_origins
    if action_name == 'show'
      if params[:origin].present?
        session[:admin_origin_level1] = params[:origin]
      elsif request.referer&.include?(admin_calendar_month_path) ||
            request.referer&.include?(admin_calendar_day_path) ||
            (request.referer&.include?(admin_reports_path) && !request.referer&.include?('/edit'))
        session[:admin_origin_level1] = request.referer
      end
      session.delete(:admin_origin_level2)
    elsif action_name == 'edit'
      session[:admin_origin_level2] = session[:admin_origin_level1]
    end
    @admin_origin_level1 = session[:admin_origin_level1]
    @admin_origin_level2 = session[:admin_origin_level2]
  end

  def report_params
    params.require(:report).permit(:report_date, :title, :contents)
  end
end
