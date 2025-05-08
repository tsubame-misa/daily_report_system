class Report < ApplicationRecord
  include ErrorMessageFormatter

  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :favorite_users, through: :favorites, source: :user

  # テーブル名とモデルクラスの対応を定義
  TABLE_MAPPINGS = {
    'reports' => { model: Report, table: arel_table },
    'users' => { model: User, table: User.arel_table }
  }.freeze

  # デフォルトの検索カラムを定義
  DEFAULT_SEARCH_COLUMNS = [
    TABLE_MAPPINGS['reports'][:table][:title],
    TABLE_MAPPINGS['reports'][:table][:contents],
    TABLE_MAPPINGS['users'][:table][:name]
  ].freeze

  scope :sorted_by, ->(column, direction) {
    column = %w[report_date title created_at].include?(column) ? column : "report_date"
    direction = %w[asc desc].include?(direction) ? direction : "desc"
    order(column => direction)
  }

  scope :by_date_range, ->(start_date, end_date) {
    where(report_date: start_date..end_date) if start_date.present? && end_date.present?
  }

  scope :keyword_search, ->(kw, search_columns = nil) {
    return all if kw.blank?

    conditions = []

    # 検索対象のカラムを決定
    search_columns = if search_columns.present?
                       begin
                         search_columns.map do |col|
                           # 文字列でない場合はスキップ
                           next unless col.is_a?(String)

                           table_name, column_name = col.split('.')
                           # テーブル名とカラム名の形式チェック
                           unless table_name.present? && column_name.present?
                             Rails.logger.warn("Invalid column format: #{col}. Expected format: 'table.column'")
                             next
                           end

                           # テーブル情報を取得
                           table_info = TABLE_MAPPINGS[table_name]
                           unless table_info
                             Rails.logger.warn("Unknown table: #{table_name}")
                             next
                           end

                           # カラムが存在するか確認
                           unless table_info[:model].column_names.include?(column_name)
                             Rails.logger.warn("Column #{column_name} does not exist in table #{table_name}")
                             next
                           end

                           table_info[:table][column_name]
                         end.compact
                       rescue ArgumentError
                         Rails.logger.warn("Invalid format for search_columns: #{search_columns}")
                         DEFAULT_SEARCH_COLUMNS
                       end
                     else
                       DEFAULT_SEARCH_COLUMNS
                     end

    # 検索条件が空の場合はデフォルトの検索カラムを使用
    if search_columns.empty?
      Rails.logger.warn("No valid search columns found. Using default columns.")
      search_columns = DEFAULT_SEARCH_COLUMNS
    end

    # 検索条件を構築
    search_columns.each do |column|
      conditions << column.matches("%#{kw}%")
    end

    # 条件を結合して検索を実行
    joins(:user).where(conditions.reduce(:or))
  }

  # validates :date, presence: true

  validates :report_date, uniqueness: {
    scope: :user_id,
    message: "同じ日付の日報はすでに存在します。"
  }, presence: true
  validates :title, presence: true
  validates :contents, presence: true
end
