module ReportsHelper
  # _formで表示される日報の日付を決定する
  # 優先順位:
  # 1. report.report_date
  # 2. URLパラメータのdate
  # 3. 今日の日付
  def determine_report_date(report)
    return report.report_date if report.report_date.present?
    return Date.parse(params[:date]) if params[:date].present?

    Date.today
  end
end
