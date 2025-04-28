class Report < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :favorite_users, through: :favorites, source: :user

  # validates :date, presence: true
  validates :title, presence: true
  validates :contents, presence: true
  validates :report_date, uniqueness: {
    scope: :user_id,
    message: "同じ日付の日報はすでに存在します。"
  }, presence: true
end
