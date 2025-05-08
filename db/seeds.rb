require 'csv'

# ユーザーの作成
# CSVファイルが存在するか確認
users_csv_path = Rails.root.join('db/data', 'users_v4.csv')
if File.exist?(users_csv_path) && !File.zero?(users_csv_path)
  puts "Importing users from #{users_csv_path}..."
  
  # CSVからユーザーを読み込む
  users = {}
  CSV.foreach(users_csv_path, headers: true) do |row|
    user = User.find_or_create_by!(email: row['email']) do |u|
      u.name = row['name']
      u.password = row['password'] || 'password'
      u.password_confirmation = row['password'] || 'password'
      u.role = row['role'] || 1  # デフォルトは一般ユーザー(1)
    end
    users[user.email] = user
    puts "Created user: #{user.name} (#{user.email})"
  end
  
  puts "Successfully imported #{users.size} users."
else
  # CSVが存在しないか空の場合はデフォルトのユーザーを作成
  puts "CSV file not found or empty. Creating default users..."
  
  # 管理者ユーザー
  admin1 = User.find_or_create_by!(email: 'admin1@example.com') do |user|
    user.name = 'Admin1'
    user.password = 'password'
    user.password_confirmation = 'password'
    user.role = 0
  end
  
  # メンバーユーザー
  users = {}
  (1..9).each do |i|
    user = User.find_or_create_by!(email: "member#{i}@example.com") do |u|
      u.name = "Member#{i}"
      u.password = 'password'
      u.password_confirmation = 'password'
      u.role = 1
    end
    users[user.email] = user
  end
  
  users['admin1@example.com'] = admin1
  puts "Created #{users.size} default users."
end

# レポートの作成
# CSVファイルが存在するか確認
reports_csv_path = Rails.root.join('db/data', 'reports_v4.csv')
if File.exist?(reports_csv_path) && !File.zero?(reports_csv_path)
  puts "Importing reports from #{reports_csv_path}..."
  
  # CSVからレポートを読み込む
  reports_count = 0
  CSV.foreach(reports_csv_path, headers: true) do |row|
    user_email = row['user_email']
    user = users[user_email]
    
    # ユーザーが存在する場合のみレポートを作成
    if user
      report = Report.find_or_create_by!(
        user_id: user.id,
        title: row['title'],
        report_date: Date.parse(row['report_date'])
      ) do |r|
        r.contents = row['contents']
      end
      reports_count += 1
    else
      puts "Warning: User with email #{user_email} not found. Skipping report."
    end
  end
  
  puts "Successfully imported #{reports_count} reports."
else
  # CSVが存在しないか空の場合はデフォルトのレポートを作成
  puts "CSV file not found or empty. Creating default reports..."
  
  # 全ユーザーに対して5つのレポートを作成
  reports_count = 0
  users.values.each do |user|
    (1..5).each do |j|
      Report.find_or_create_by!(title: "#{user.name}_report#{j}", user_id: user.id) do |report|
        report.contents = "#{user.name}の#{j}番目のレポートです。\n本日の業務内容や進捗を記載します。"
        report.report_date = Date.new(2025, 4, 25 + j - 1)
      end
      reports_count += 1
    end
  end
  
  puts "Created #{reports_count} default reports."
end

puts "Seed completed successfully!"
