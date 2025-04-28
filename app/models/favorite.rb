class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :report

  validates :user_id, uniqueness: { scope: :report_id }
end
