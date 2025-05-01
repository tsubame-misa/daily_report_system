class User < ApplicationRecord
  include ErrorMessageFormatter

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :reports, dependent: :destroy
  has_many :favorites, dependent: :destroy

  validates :name, presence: true, length: { maximum: 255 }
  validates :email, presence: true, uniqueness: true, length: { maximum: 255 }
  validates :password, presence: true, length: { minimum: 6 }, if: :password_required?
  validates :password_confirmation, presence: true, if: :password_required?
  # role はデフォルトで1が選択されているため、バリデーションは不要

  # role が 0 なら管理者
  def admin?
    role == 0
  end

  def ordered_errors
    order = [:name, :email, :password, :password_confirmation]
    ordered_messages = []

    # 実際にエラーが発生している属性に基づいて順序を適用
    order.each do |attribute|
      errors.full_messages_for(attribute).each do |message|
        ordered_messages << message
      end
    end
    ordered_messages
  end
end
