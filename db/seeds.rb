User.find_or_create_by!(email: "admin@example.com") do |user|
  user.name = "Admin"
  user.password = "password"
  user.password_confirmation = "password"
  user.role = 0
end