class ChangeColumnNotNullToReports < ActiveRecord::Migration[7.0]
  def change
    change_column_null :reports, :report_date, false
  end
end
