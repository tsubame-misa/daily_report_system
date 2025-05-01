module ErrorMessageFormatter
  extend ActiveSupport::Concern

  def formatted_error_messages
    # 空欄エラーのカラム名を集める
    missing_fields = errors.select { |error| error.type == :blank }.map do |error|
      # 日本語の要素名はconfig/locales/ja.ymlに定義
      self.class.human_attribute_name(error.attribute)
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
