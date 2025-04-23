class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :reports, dependent: :destroy

  # role が 0 なら管理者
  def admin?
    role == 0
  end
end