# 管理者ユーザー
admin1 = User.find_or_create_by!(email: 'admin1@example.com') do |user|
  user.name = 'Admin1'
  user.password = 'password'
  user.password_confirmation = 'password'
  user.role = 0
end

# メンバーユーザー
users = []
(1..9).each do |i|
  user = User.find_or_create_by!(email: "member#{i}@example.com") do |u|
    u.name = "Member#{i}"
    u.password = 'password'
    u.password_confirmation = 'password'
    u.role = 1
  end
  users << user
end

# 全ユーザー（管理者含む）の配列を作成
all_users = [admin1] + users

# 各ユーザーに対して5つのレポートを作成
all_users.each do |user|
  (1..5).each do |j|
    Report.find_or_create_by!(title: "#{user.name}_report#{j}", user_id: user.id) do |report|
      report.contents = "#{user.name}の#{j}番目のレポートです。\n本日の業務内容や進捗を記載します。"
      report.report_date = Date.new(2025, 4, 25 + j - 1)
    end
  end
end
