admin1 = User.find_or_create_by!(email: 'admin1@example.com') do |user|
  user.name = 'Admin1'
  user.password = 'password'
  user.password_confirmation = 'password'
  user.role = 0
end

Report.find_or_create_by!(title: 'admin1_title1', contents: 'admin1_contents1') do |report|
  report.user_id = admin1.id
  report.title = 'admin1_title1'
  report.contents = 'admin1_contents1'
  report.report_date = Date.new(2025, 4, 25)
end

Report.find_or_create_by!(title: 'admin1_title2', contents: 'admin1_contents2') do |report|
  report.user_id = admin1.id
  report.title = 'admin1_title2'
  report.contents = 'admin1_contents2'
  report.report_date = Date.new(2025, 4, 26)
end

member1 = User.find_or_create_by!(email: 'member1@example.com') do |user|
  user.name = 'Member1'
  user.password = 'password'
  user.password_confirmation = 'password'
  user.role = 1
end

Report.find_or_create_by!(title: 'member1_title1', contents: 'member1_contents1') do |report|
  report.user_id = member1.id
  report.title = 'member1_title1'
  report.contents = 'member1_contents1'
  report.report_date = Date.new(2025, 4, 25)
end

Report.find_or_create_by!(title: 'member1_title2', contents: 'member1_contents2') do |report|
  report.user_id = member1.id
  report.title = 'member1_title2'
  report.contents = 'member1_contents2'
  report.report_date = Date.new(2025, 4, 26)
end
