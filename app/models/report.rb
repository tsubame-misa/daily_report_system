class Report < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :favorite_users, through: :favorites, source: :user

  scope :sorted_by, ->(column, direction) {
    column = %w[report_date title].include?(column) ? column : "report_date"
    direction = %w[asc desc].include?(direction) ? direction : "desc"
    order(column => direction)
  }

  scope :by_date_range, ->(start_date, end_date) {
    where(report_date: start_date..end_date) if start_date.present? && end_date.present?
  }

  # validates :date, presence: true

  validates :report_date, uniqueness: { 
    scope: :user_id,
    message: "同じ日付の日報はすでに存在します。"
  }, presence: true
  validates :title, presence: true
  validates :contents, presence: true
end
