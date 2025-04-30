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
  scope :keyword_search, ->(kw) {
    return all if kw.blank?

    # reports の title, contents と user.name を部分一致で検索
    reports_table = arel_table
    users_table   = User.arel_table

    title_match = reports_table[:title].matches("%#{kw}%")
    contents_match = reports_table[:contents].matches("%#{kw}%")
    user_name_match = users_table[:name].matches("%#{kw}%")

    joins(:user)
      .where(title_match.or(contents_match).or(user_name_match))
  }

  # validates :date, presence: true

  validates :report_date, uniqueness: {
    scope: :user_id,
    message: "同じ日付の日報はすでに存在します。"
  }, presence: true
  validates :title, presence: true
  validates :contents, presence: true

  def formatted_error_messages
    # 空欄エラーのカラム名を集める
    missing_fields = errors.select { |error| error.type == :blank }.map do |error|
      case error.attribute
      when :title then "タイトル"
      when :contents then "内容"
      when :report_date then "日付"
        # 必要に応じて他のカラムも
      end
    end.compact.uniq

    # 空欄以外のエラーメッセージを集める
    other_errors = errors.filter_map do |error|
      unless error.type == :blank
        error.full_message
      end
    end

    # メッセージを組み立てる
    messages = []
    messages << "#{missing_fields.join('・')}を入力してください" if missing_fields.any?
    messages.concat(other_errors) if other_errors.any?
    messages.join('<br>')
  end
end
