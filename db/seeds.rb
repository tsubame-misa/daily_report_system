admin = User.find_or_create_by!(email: 'admin@example.com') do |user|
  user.name = 'Admin'
  user.password = 'password'
  user.password_confirmation = 'password'
  user.role = 0
end

Report.find_or_create_by!(title: 'admin_title1', contents: 'admin_contents1') do |report|
  report.user_id = admin.id
  report.title = 'admin_title1'
  report.contents = 'admin_contents1'
end

Report.find_or_create_by!(title: 'admin_title2', contents: 'admin_contents2') do |report|
  report.user_id = admin.id
  report.title = 'admin_title2'
  report.contents = 'admin_contents2'
end

member = User.find_or_create_by!(email: 'member@example.com') do |user|
  user.name = 'Member'
  user.password = 'password'
  user.password_confirmation = 'password'
  user.role = 1
end

Report.find_or_create_by!(title: 'member_title1', contents: 'member_contents1') do |report|
  report.user_id = member.id
  report.title = 'member_title1'
  report.contents = 'member_contents1'
end

Report.find_or_create_by!(title: 'member_title2', contents: 'member_contents2') do |report|
  report.user_id = member.id
  report.title = 'member_title2'
  report.contents = 'member_contents2'
end
