user = User.find_or_create_by!(email: 'admin@example.com') do |user|
  user.name = 'Admin'
  user.password = 'password'
  user.password_confirmation = 'password'
  user.role = 0
end

user2 = User.find_or_create_by!(email: 'user2@example.com') do |user|
  user.name = 'User2'
  user.password = 'password'
  user.password_confirmation = 'password'
  user.role = 1
end

Report.find_or_create_by!(title: 'test_title', contents: 'test_contents') do |report|
  report.user_id = user.id
  report.title = 'test_title'
  report.contents = 'test_contents'
end

Report.find_or_create_by!(title: 'test2_title', contents: 'test2_contents') do |report|
  report.user_id = user.id
  report.title = 'test2_title'
  report.contents = 'test2_contents'
end

Report.find_or_create_by!(title: 'test3_title', contents: 'test3_contents') do |report|
  report.user_id = user2.id
  report.title = 'test3_title'
  report.contents = 'test3_contents'
end