class Report < ApplicationRecord
  belongs_to :user

  scope :sorted_by, ->(column, direction) {
    column = %w[report_date title].include?(column) ? column : "report_date"
    direction = %w[asc desc].include?(direction) ? direction : "desc"
    order(column => direction)
  }

  # validates :date, presence: true
  validates :title, presence: true
  validates :contents, presence: true
  validates :report_date, uniqueness: { 
    scope: :user_id,
    message: "同じ日付の日報はすでに存在します。"
  }, presence: true

    
end
